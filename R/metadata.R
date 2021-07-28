#' Generate data details
#'
#' Metadata about input data including file paths, column names, time zones and EPSG codes.
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
#' @param epsgin EPSG code of input. if numeric, EPSG code to use for all rows. if character, column name of EPSG code in DT
#' @param epsgout local projection EPSG code to reproject long+lat into
#'
#' @return
#' @author Alec L. Robitaille
#' @export
#'
#' @examples
metadata <- function() {
	rbindlist(list(
		data.table(
			path = '../fogo-caribou/data/FogoCaribou.csv',
			name = 'NL-Fogo-Caribou-Telemetry',
			long = 'X_COORD',
			lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			datetime = 'datetime',
			extracols = NA,
			tz = grep('Newfoundland', OlsonNames(), value = TRUE),
			epsgin = 4326, #TODO: CHECK
			epsgout = 32621
		),
		data.table(
			path = '../metadata/data/NL/Provincial/Caribou/Telemetry/AllCaribouDataRaw.csv',
			name = 'NL-Provincial-Caribou-Telemetry',
			long = 'X_COORD',
			lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			date = 'FIX_DATE',
			time = 'FIX_TIME',
			extracols = list(list('COLLAR_TYPE_CL', 'HERD', 'Map_Quality', 'LOCQUAL', 'EPSG_CODE', 'EXCLUDE')),
			tz = 'UTC',
			epsgin = 'EPSG_CODE',
			epsgout = 32621,
			splitBy = 'HERD'
		)
	),
	fill = TRUE)

	# TODO: if movebank then dir() paths and fill NAs once
}


