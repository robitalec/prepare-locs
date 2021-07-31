#' Check locs
#'
#' using functions check_longlat and check_loc_meta
#'
#' @param DT
#' @param meta
#'
#' @return
#' @export
#' @author Alec L. Robitaille
#'
#' @examples
check_locs <- function(DT, meta) {
	data.table::setalloccol(DT)
	check_longlat(DT)
	check_locs_meta(DT)

	if (!is.na(meta$deployment)) check_deployment(DT, meta)

	DT[!is.na(flag), c('x_long', 'y_lat') := NaN]
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
	data.table::setalloccol(DT)

	if (DT[, !is.numeric(x_long)]) DT[, x_long := is.numeric(x_long)]
	if (DT[, !is.numeric(y_lat)]) DT[, y_lat := is.numeric(y_lat)]

	data.table::set(DT, j = 'flag', value = NA_character_)
	DT[!between(x_long, -180, 360), flag := why(flag, 'x_long not between -180, 360')]
	DT[!between(y_lat, -90, 90), flag := why(flag, 'y_lat not between -90, 90')]

	DT[x_long == 0,  flag := why(flag, 'x_long is 0')]
	DT[y_lat == 0,  flag := why(flag, 'y_lat is 0')]

	DT[x_long == y_lat, flag := why(flag, 'x_long == y_lat')]

	DT[is.na(x_long), flag := why(flag, 'x_long is NA')]
	DT[is.nan(x_long), flag := why(flag, 'x_long is NaN')]
	DT[is.na(y_lat), flag := why(flag, 'y_lat is NA')]
	DT[is.nan(y_lat), flag := why(flag, 'y_lat is NaN')]

	DT[duplicated(DT, by = c('id', 'doy', 'yr', 'x_long', 'y_lat')), flag := why(flag, 'loc is duplicated')]

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
	data.table::setalloccol(DT)

	# if ('SEX' %in% colnames(DT)) {
	# 	DT[grepl('F', SEX)]
	# }

	if ('Map_Quality' %in% colnames(DT)) {
		DT[Map_Quality == 'N', flag := why(flag, 'Map_Quality is N')]
		data.table::set(DT, j = 'Map_Quality', value = NULL)
	}

	if ('EXCLUDE' %in% colnames(DT)) {
		DT[EXCLUDE == 'Y', flag := why(flag, 'EXCLUDE is Y')]
		data.table::set(DT, j = 'EXCLUDE', value = NULL)
	}

	if ('DOP' %in% colnames(DT)) {
		DT[DOP > 10, flag := why(flag, 'DOP > 10')]
		data.table::set(DT, j = 'DOP', value = NULL)
	}

	if ('NAV' %in% colnames(DT)) {
		DT[NAV %in% c('2D', 'No'), flag := why(flag, paste('NAV is', NAV))]
		data.table::set(DT, j = 'NAV', value = NULL)

	}

	if ('COLLAR_TYPE_CL' %in% colnames(DT)) {
		DT[COLLAR_TYPE_CL != 'GPS', flag := why(flag, paste('Collar type is', COLLAR_TYPE_CL))]
		data.table::set(DT, j = 'COLLAR_TYPE_CL', value = NULL)
	}

	if ('status' %in% colnames(DT)) {
		DT[!grepl('3D', status), flag := why(flag, 'status is not 3D')]
		data.table::set(DT, j = 'status', value = NULL)
	}

	DT
}



#' Check deployment
#'
#' @param DT
#' @param meta metadata with variable 'deployment' indicating path to csv with three columns indicating 'id' animal id, 'start_date' start of deployment and 'end_date' end of deployment both structured as 'YYYY-MM-DD' formatted character
#'
#' @return
#' @export
#'
#' @examples
check_deployment <- function(DT, meta) {
	deploy <- data.table::fread(meta$deployment)

	DT[deploy,
		 flag := why(flag, 'fix date before deployment'),
		 on = .(id == id, idate < start_date)]

	DT[deploy,
		 flag := why(flag, 'fix date after deployment'),
		 on = .(id == id, idate > end_date)]

	DT
}




#' Why flag why
#'
#' Appends flag to existing flag(s)
#'
#' @param flag
#' @param why
#'
#' @return
#' @export
#'
#' @examples
why <- function(flag, why) {
	data.table::fifelse(is.na(flag), why, paste(flag, why, sep = '; '))
}
