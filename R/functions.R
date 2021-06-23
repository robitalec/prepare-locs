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
select_cols <- function(DT, x, y, id, date = NULL, time = NULL, datetime = NULL, extracols = NULL) {
	check_missing(DT, 'input DT')
	check_truelength(DT)
	check_missing(x, 'x column name')
	check_missing(y, 'y column name')
	check_missing(id, 'id column name')

	if ((is.null(date) & is.null(datetime)) |
			(is.null(time) & is.null(datetime))) {
		stop('must provide either date and time, or datetime')
	}
	if ((!is.null(date) & !is.null(datetime)) |
			(!is.null(time) & !is.null(datetime))) {
		stop('must provide either date and time, or datetime')
	}


	incols <- colnames(DT)
	outcols <- c(id, datetime, x, y)

	if (is.null(datetime)) {
		DT[, datetime := paste(.SD[[1]], .SD[[2]]), .SDcols = c(date, time)]
	}

	outcols <- c(id, 'datetime', x, y)
	outcolsnames <- c('id', 'datetime', 'X', 'Y')

	if (!is.null(extracols)) {
		outcols <- c(outcols, unlist(extracols))
		outcolsnames <- c(outcolsnames, unlist(extracols))
	}

	lapply(outcols, function(x) check_col(DT, x))
	outcols
	data.table::setnames(DT, outcols, outcolsnames)
	data.table::setcolorder(DT, outcolsnames)
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
#' @param epsg numeric; EPSG code
#'
#' @return
#' @export
#'
#' @examples
project_locs <- function(DT, epsg) {
	check_truelength(DT)

	coords <- c('X', 'Y')
	projcoords <- paste0('proj', coords)

	lapply(coords, function(x) check_col(DT, x))
	lapply(coords, function(x) check_type(DT, x, 'double'))
	lapply(projcoords, function(x) overwrite_col(DT, x))

	DT[, (projcoords) :=
		 	data.table::as.data.table(
		 		rgdal::project(
		 			as.matrix(.SD, ncol = 2),
		 			sf::st_crs(epsg)$wkt)
		 	),
		 .SDcols = coords]
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


check_missing <- function(x, name) {
	if (missing(x)) {
		stop('must provide ', name,)
	}
}
