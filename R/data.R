# data.table(
# 	path = ,
# 	id = ,
# 	datetime = ,
# 	long = ,
# 	lat = ,
# 	extracols ,
# 	tz = ,
# 	epsg =
# )

#' Generate data details
#'
#'
#' @param path filepath
#' @param long unprojected longitude coordinate column name
#' @param lat unprojected latitude coordinate column name
#' @param id individual identifier column name
#' @param datetime datetime column name. either provide datetime or both date and time
#' @param date date column name. either provide both date and time or datetime
#' @param time time column name. either provide both date and time or datetime
#' @param extracols list of extra column names to preserve
#' @param tz time zone of datetime columns as stored in the input file
#' @param epsg local projection EPSG code to reproject long+lat into
#'
#' @return
#' @export
#'
#' @examples
data_details <- function() {
	rbindlist(list(
		data.table(
			path = '../fogo-caribou/data/FogoCaribou.csv',
			long = 'X_COORD',
			lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			datetime = 'datetime',
			extracols = NA,
			tz = grep('Newfoundland', OlsonNames(), value = TRUE),
			epsg = 32621
		),
		data.table(
			path = '../metadata/data/NL/Provincial/Caribou/Telemetry/AllCaribouDataRaw.csv',
			long = 'X_COORD',
			lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			date = 'FIX_DATE',
			time = 'FIX_TIME',
			extracols = list(list('HERD', 'Map_Quality', 'LOCQUAL')),
			tz = grep('Newfoundland', OlsonNames(), value = TRUE),
			epsg = 32621
		)
	),
	fill = TRUE)
}


