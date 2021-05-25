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
