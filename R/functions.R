# === Functions -----------------------------------------------------------
# Alec Robitaille


#' Read data
#'
#' @param path character; path to input file. passed to fread.
#'
#' @return
#' data.table
#' @export
#' @import data.table
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
read_data <- function(path) {
	data.table::fread(path)
}


#' Select cols
#'
#' @inheritParams read_date
#' @inheritParams cast_columns
#' @inheritParams prep_dates
#' @param extracols character vector; list of column names to include (eg. for group_pts splitBy)
#' @return
#' Input DT with only selected columns id, datetime, coords and any column provided in extracols
#' @export
#'
#' @examples
select_cols <- function(DT, id, datetime, coords, extracols = NULL) {

	check_truelength(DT)

	incols <- colnames(DT)

	outcols <- c(id, datetime, coords, extracols)
	outcolsnames <- c('id', 'datetime', 'X', 'Y', extracols)

	lapply(outcols, function(x) check_col(DT, x))

	dropcols <- incols[!incols %in% outcols]

	if (length(dropcols) > 0) {
		data.table::set(DT, j = dropcols, value = NULL)
	}

	data.table::setcolorder(DT, outcols)

	data.table::setnames(DT, outcols, outcolsnames)

	DT
}


#' Cast columns
#'
#' @param DT data.table
#'
#' @return
#' data.table
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' cast_cols(DT)
cast_cols <- function(DT) {
	check_truelength(DT)

	DT[, id := as.character(id)]
}

#' Prepare datetime column
#'
#' @param tz character; time zone.
#' @inheritParams cast_cols
#'
#' @return
#' data.table with datetime in UTC time, idate, itime and DOY
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' prep_dates(DT, 'Canada/Newfoundland')
prep_dates <- function(DT, tz) {
	check_truelength(DT)
	check_col(DT, datetime, 'datetime')

	if (missing(tz)) {
		stop('must provide a tz argument')
	}

	DT[, datetime := parsedate::parse_date(datetime, default_tz = tz)]

	DT[, idate := data.table::as.IDate(datetime)]
	DT[, itime := data.table::as.ITime(datetime)]

	DT[, doy := data.table::yday(idate)]
	DT[, yr := data.table::year(idate)]
	DT[, mnth := data.table::month(idate)]
}



#' Project locs
#' @inheritParams prep_dates
#' @param coords character vector; coordinate column names eg. c('X', 'Y'). Assumes input is WGS84 EPSG: 4326
#' @param projection character; Character representation of projection passable to rgdal::project. For example sf::st_crs(4326)$wkt is great!
#'
#' @return
#' @export
#'
#' @examples
project_locs <- function(DT, coords, projection, projcoords = c('EASTING', 'NORTHING')) {
	check_truelength(DT)
	lapply(coords, function(x) check_col(DT, x))
	lapply(coords, function(x) check_type(DT, x, 'double'))
	lapply(projcoords, function(x) overwrite_col(DT, x))

	DT[, (projcoords) :=
		 	data.table::as.data.table(
		 		rgdal::project(
		 			as.matrix(.SD, ncol = 2),
		 			projection)
		 	),
		 .SDcols = coords][]
}




filter_locs <- function(DT) {
	if ('SEX' %in% colnames(DT)) {
		DT[grepl('F', SEX)]
	}


	# TODO: ask Map_Quality
	if ('Map_Quality' %in% colnames(DT)) {
		DT[Map_Quality == 'Y']
	}
	# TODO: ask LOCQUAL
	if ('LOCQUAL' %in% colnames(DT)) {
		# DT[LOCQUAL %in% c(1, 2, 3)]
	}
	# TODO: ask EXCLUDE, VALIDATED

	if ('COLLAR_TYPE_CL' %in% colnames(DT)) {
		DT[COLLAR_TYPE_CL == 'GPS']
	}
}
