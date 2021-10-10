#' Prepare datetime column
#'
#' @param tz character; time zone of the data **input**, as it is stored the file.
#' @inheritParams cast_cols
#'
#' @return
#' data.table with datetime in UTC time, idate, itime and DOY
#' @export
#' @author Alec L. Robitaille
#'
#' @examples
prep_dates <- function(DT, tz) {
	data.table::setalloccol(DT)
	check_col(DT, 'datetime', 'datetime')

	if (missing(tz)) {
		stop('must provide a tz argument')
	}

	DT[, datetime := parsedate::parse_date(datetime, default_tz = tz)]

	DT[, idate := data.table::as.IDate(datetime)]

	DT[, doy := data.table::yday(idate)]
	DT[, yr := data.table::year(idate)]
	DT[, mnth := data.table::month(idate)]
}
