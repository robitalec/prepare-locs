# === Prepare relocations -------------------------------------------------
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

	lapply(outcols, function(x) check_col(DT, x))

	dropcols <- incols[!incols %in% outcols]

	if (length(dropcols) > 0) {
		data.table::set(DT, j = dropcols, value = NULL)
	}

	data.table::setcolorder(DT, outcols)

	# data.table::setnames(DT, outcols, c('id', 'datetime', 'X', 'Y', extracols))

	DT
}


#' Cast columns
#'
#' @param DT data.table
#' @param id character; id column name
#'
#' @return
#' data.table
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' cast_cols(DT, id)
cast_cols <- function(DT, id) {
	check_truelength(DT)
	check_col(DT, id, 'id')

	DT[, (id) := as.character(.SD[[1]]), .SDcols = id]
}

#' Prepare datetime column
#'
#' @param datetime character; datetime column name
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
#' prep_dates(DT, 'datetime', 'Canada/Newfoundland')
prep_dates <- function(DT, datetime, tz) {
	check_truelength(DT)
	check_col(DT, datetime, 'datetime')

	# Format: yyyy-MM-dd HH:mm:ss.SSS
	# Units: UTC or GPS time

	# if (movebank) {
	# 	tz <- 'UTC'
	# }

	if (missing(tz)) {
		stop('must provide a tz argument')
	}

	DT[, datetime := anytime::anytime(.SD[[1]], tz = tz, asUTC = TRUE), .SDcols = datetime]

	DT[, idate := data.table::as.IDate(datetime)]
	DT[, itime := data.table::as.ITime(datetime)]

	DT[, doy := data.table::yday(idate)]
	DT[, yr := data.table::year(idate)]
	DT[, mnth := data.table::month(idate)]
}



#' Calc NPP date ranges
#'
#' GPP+NPP product MOD17A2H has 8-day aggretates, summing NPP in each pixel over
#' 8-day period. 45 8-day ranges, but the last range (the 46th) is either
#' 5 or 6 days depending on if it is a leap year or not
#'
#' @param DT
#' @param doy
#' @param year
#'
#' @return
#' @export
#'
#' @examples
calc_npp_date_ranges <- function(DT, doy = 'doy', year = 'yr') {
	DT[, isleap := chron::leap.year(yr)]

	sjuls <- seq.int(1, 367, by = 8)
	nppdates <- data.table(
		lowjul = sjuls,
		highjul = c(sjuls[-1], 367),
		divby = c(rep(8, 45), 5)
	)

	joinexpr <- c(paste0(doy, ' >= lowjul'), paste0(doy, ' < highjul'))
	DT[nppdates, (names(nppdates)) := .(lowjul, highjul, divby), on = joinexpr]
	DT[(isleap) & divby == 5, divby := 6]
	DT
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



#' Prepare relocations
#'
#' @inheritParams read_data
#' @inheritParams cast_cols
#' @inheritParams prep_dates
#'
#' @return
#' @export
#'
#' @examples
#' path <- system.file('extdata', 'DT.csv', package = 'spatsoc')
#' DT <- read_data(path = path)
#' prep_locs(DT, 'datetime', 'Canada/Newfoundland')
prep_locs <- function(path, id, datetime, coords, projection,
											projcoords = c('EASTING', 'NORTHING'),
											tz, extracols = NULL) {
	DT <- read_data(
		path = path
	)

	select_cols(
		DT = DT,
		id = id,
		datetime = datetime,
		coords = coords,
		extracols = extracols
	)


	cast_cols(
		DT,
		id = id
	)

	prep_dates(
		DT,
		datetime,
		tz
	)

	calc_npp_date_ranges(
		DT
	)

	project_locs(
		DT = DT,
		coords = coords,
		projection = projection,
		projcoords = projcoords
	)

}



