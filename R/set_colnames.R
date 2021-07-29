#' Set consistent column names
#'
#' @inheritParams read_date
#' @inheritParams cast_columns
#' @inheritParams prep_dates
#' @param extracols character vector; list of column names to include (eg. for group_pts splitBy)
#' @return
#' Input DT with only selected columns id, datetime, coords and any column provided in extracols
#' @export
#' @author Alec L. Robitaille
#'
#' @examples
set_colnames <- function(DT, long, lat, id, date = NULL, time = NULL, datetime = NULL, extracols = NULL) {
	check_missing(DT, 'input DT')
	data.table::setalloccol(DT)
	check_missing(long, 'long column name')
	check_missing(lat, 'lat column name')
	check_missing(id, 'id column name')

	if (is.na(datetime) & !is.na(date) & !is.na(time)){
		DT[, datetime := paste(.SD[[1]], .SD[[2]]), .SDcols = c(date, time)]
	} else if (!is.na(datetime) & is.na(date) & is.na(time)) {
		DT[, datetime := .SD, .SDcols = c(datetime)]
	} else {
		stop('must provide either date and time, or only datetime')
	}

	incols <- colnames(DT)
	outcols <- c('name', id, 'datetime', long, lat)
	outcolsnames <- c('name', 'id', 'datetime', 'long', 'lat')

	if (!is.na(extracols)) {
		outcols <- c(outcols, unlist(extracols))
		outcolsnames <- c(outcolsnames, unlist(extracols))
	}

	lapply(outcols, function(x) check_col(DT, x))
	data.table::setnames(DT, outcols, outcolsnames)
	data.table::setcolorder(DT, outcolsnames)
	DT[, .SD, .SDcols = outcolsnames]
}
