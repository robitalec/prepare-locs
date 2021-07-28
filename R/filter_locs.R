#' Filter locs
#'
#' using functions check_longlat and check_loc_meta
#'
#' @param DT
#'
#' @return
#' @export
#' @author Alec L. Robitaille
#'
#' @examples
filter_locs <- function(DT) {
	check_longlat(DT)
	check_locs_meta(DT)
	DT[!is.na(drop), c('long', 'lat') := NaN]
	return(DT)
}


#' Check long and lat
#'
#' @param DT data.table
#'
#' @return
#' data.table
#' @author Alec L. Robitaille
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' check_longlat(DT)
check_longlat <- function(DT) {
	check_truelength(DT)

	if (DT[, !is.numeric(long)]) DT[, long := is.numeric(long)]
	if (DT[, !is.numeric(lat)]) DT[, lat := is.numeric(lat)]

	DT[!between(long, -180, 360), drop := why(drop, 'long not between -180, 360')]
	DT[!between(lat, -90, 90), drop := why(drop, 'lat not between -90, 90')]

	DT[long == 0,  drop := why(drop, 'long is 0')]
	DT[lat == 0,  drop := why(drop, 'lat is 0')]

	DT[long == lat, drop := why(drop, 'long == lat')]

	DT[is.na(long), drop := why(drop, 'long is NA')]
	DT[is.nan(long), drop := why(drop, 'long is NaN')]
	DT[is.na(lat), drop := why(drop, 'lat is NA')]
	DT[is.nan(lat), drop := why(drop, 'lat is NaN')]

	DT
}

#' Check loc meta
#'
#' Check location data's meta information eg. map quality, DOP, manual exclusion
#'
#' @param DT data.table
#'
#' @return
#' data.table
#' @export
#' @author Alec L. Robitaille
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' check_longlat(DT)
check_locs_meta <- function(DT) {
	# if ('SEX' %in% colnames(DT)) {
	# 	DT[grepl('F', SEX)]
	# }

	if ('Map_Quality' %in% colnames(DT)) {
		DT[Map_Quality == 'N', drop := why(drop, 'Map_Quality is N')]
		DT[, Map_Quality := NULL]
	}

	if ('EXCLUDE' %in% colnames(DT)) {
		DT[EXCLUDE == 'Y', drop := why(drop, 'EXCLUDE is Y')]
		DT[, EXCLUDE := NULL]
	}

	if ('LOCQUAL' %in% colnames(DT)) {
		# DT[LOCQUAL %in% c(1, 2, 3)]
		# TODO LOCQUAL
		# DT[, LOCQUAL := NULL]
	}

	# TODO: VALIDATED

	if ('COLLAR_TYPE_CL' %in% colnames(DT)) {
		DT[COLLAR_TYPE_CL != 'GPS', drop := why(drop, paste0('Collar type is', COLLAR_TYPE_CL))]
		DT[, COLLAR_TYPE_CL := NULL]
	}
}



why <- function(drop, why) {
	data.table::fifelse(is.na(drop), why, paste(drop, why, sep = ', '))
}
