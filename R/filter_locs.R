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
filter_locs <- function(DT, deployment = NA) {
	check_truelength(DT)
	check_longlat(DT)
	check_locs_meta(DT)

	if (!is.na(deployment)) check_deployment(DT)

	DT[!is.na(flag), c('long', 'lat') := NaN]
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

	data.table::set(DT, j = 'flag', value = NA_character_)
	DT[!between(long, -180, 360), flag := why(flag, 'long not between -180, 360')]
	DT[!between(lat, -90, 90), flag := why(flag, 'lat not between -90, 90')]

	DT[long == 0,  flag := why(flag, 'long is 0')]
	DT[lat == 0,  flag := why(flag, 'lat is 0')]

	DT[long == lat, flag := why(flag, 'long == lat')]

	DT[is.na(long), flag := why(flag, 'long is NA')]
	DT[is.nan(long), flag := why(flag, 'long is NaN')]
	DT[is.na(lat), flag := why(flag, 'lat is NA')]
	DT[is.nan(lat), flag := why(flag, 'lat is NaN')]

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
	check_truelength(DT)

	# if ('SEX' %in% colnames(DT)) {
	# 	DT[grepl('F', SEX)]
	# }

	if ('Map_Quality' %in% colnames(DT)) {
		DT[Map_Quality == 'N', flag := why(flag, 'Map_Quality is N')]
		DT[, Map_Quality := NULL]
	}

	if ('EXCLUDE' %in% colnames(DT)) {
		DT[EXCLUDE == 'Y', flag := why(flag, 'EXCLUDE is Y')]
		DT[, EXCLUDE := NULL]
	}

	if ('DOP' %in% colnames(DT)) {
		DT[DOP > 10, flag := why(flag, 'DOP > 10')]
		DT[, DOP := NULL]
	}

	if ('NAV' %in% colnames(DT)) {
		DT[NAV %in% c('2D', 'No'), flag := why(flag, paste('NAV is', NAV))]
		DT[, NAV := NULL]
	}

	if ('COLLAR_TYPE_CL' %in% colnames(DT)) {
		DT[COLLAR_TYPE_CL != 'GPS', flag := why(flag, paste('Collar type is', COLLAR_TYPE_CL))]
		DT[, COLLAR_TYPE_CL := NULL]
	}
}



#' Check deployment
#'
#' @param DT
#' @param deployment path to csv with three columns indicating 'id' animal id, 'start_date' start of deployment and 'end_date' end of deployment both structured as 'YYYY-MM-DD' formatted character
#'
#' @return
#' @export
#'
#' @examples
check_deployment <- function(DT, deployment) {
	deploy <- data.table::fread(deployment)

	DT[deploy,
		 flag := why(flag, 'fix date before deployment'),
		 on = .(id == id, idate < start_date)]

	DT[deploy,
		 flag := why(flag, 'fix date after deployment'),
		 on = .(id == id, idate > end_date)]

	DT
}



why <- function(flag, why) {
	data.table::fifelse(is.na(flag), why, paste(flag, why, sep = ', '))
}
