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
read_data <- function(path, details) {
	selects <- details[, na.omit(c(long, lat, id, date, time, datetime, unlist(extracols)))]

	data.table::fread(path, select = selects)
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
select_cols <- function(DT, long, lat, id, date = NULL, time = NULL, datetime = NULL, extracols = NULL) {
	check_missing(DT, 'input DT')
	check_truelength(DT)
	check_missing(long, 'long column name')
	check_missing(lat, 'lat column name')
	check_missing(id, 'id column name')

	if (is.na(datetime) & !is.na(date) & !is.na(time)){
		DT[, datetime := paste(.SD[[1]], .SD[[2]]), .SDcols = c(date, time)]
	} else if (!is.na(datetime) & is.na(date) & is.na(time)) {

	} else {
		stop('must provide either date and time, or only datetime')
	}

	incols <- colnames(DT)
	outcols <- c(id, 'datetime', long, lat)
	outcolsnames <- c('id', 'datetime', 'long', 'lat')

	if (!is.na(extracols)) {
		outcols <- c(outcols, unlist(extracols))
		outcolsnames <- c(outcolsnames, unlist(extracols))
	}

	lapply(outcols, function(x) check_col(DT, x))
	data.table::setnames(DT, outcols, outcolsnames)
	data.table::setcolorder(DT, outcolsnames)
	DT[, .SD, .SDcols = outcolsnames]
}


#' Check columns
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
#' check_cols(DT)
check_cols <- function(DT) {
	check_truelength(DT)

	DT[, id := as.character(id)]

	if (DT[, !is.numeric(long)]) DT[, long := is.numeric(long)]
	if (DT[, !is.numeric(lat)]) DT[, lat := is.numeric(lat)]

	DT[!between(long, -180, 360), long := NaN]
	DT[!between(lat, -90, 90), lat := NaN]

	DT[is.na(long) | is.nan(long), lat := NaN]
	DT[is.na(lat) | is.nan(long), long := NaN]

	DT[long == 0 | lat == 0, c('lat', 'long') := NaN]

	DT
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
	check_col(DT, 'datetime', 'datetime')

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
#' @param EPSG numeric; EPSG code
#'
#' @return
#' @export
#'
#' @examples
project_locs <- function(DT, epsgin, epsgout) {
	check_truelength(DT)
	if (!is.numeric(epsgout)) stop("epsgout must be numeric")

	coords <- c('long', 'lat')
	projcoords <- paste0('proj', coords)

	lapply(coords, function(x) check_col(DT, x))
	lapply(coords, function(x) check_type(DT, x, 'double'))
	lapply(projcoords, function(x) overwrite_col(DT, x))

	if (is.na(as.numeric(epsgin))) {
		if (!epsgin %in% colnames(DT)) {
			stop('if epsgin is a character, it must refer to column name in DT')
		}
		check_type(DT, epsgin, 'integer')

		DT[, (projcoords) :=
			 	data.table::as.data.table(
			 		sf::sf_project(
			 			pts = as.matrix(.SD, ncol = 2),
			 			from = sf::st_crs(.BY[[1]]),
			 			keep = TRUE,
			 			to = sf::st_crs(epsgout))
			 	),
			 .SDcols = coords,
			 by = epsgin]
	} else if (!is.na(as.numeric(epsgin))) {
		DT[, (projcoords) :=
			 	data.table::as.data.table(
			 		sf::sf_project(
			 			pts = as.matrix(.SD, ncol = 2),
			 			from = sf::st_crs(as.numeric(epsgin)),
			 			keep = TRUE,
			 			to = sf::st_crs(epsgout))
			 	),
			 .SDcols = coords]
	}
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
