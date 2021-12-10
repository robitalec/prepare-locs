#' Generate data details
#'
#' Metadata about input data including file paths, column names, time zones and EPSG codes.
#'
#'
#' @param path filepath
#' @param x_long unprojected longitude coordinate column name
#' @param y_lat unprojected latitude coordinate column name
#' @param id individual identifier column name
#' @param datetime datetime column name. either provide datetime or both date and time
#' @param date date column name. either provide both date and time or datetime
#' @param time time column name. either provide both date and time or datetime
#' @param extracols list of extra column names to preserve
#' @param tz time zone of datetime columns as stored in the input file
#' @param epsgin EPSG code of input. if numeric, EPSG code to use for all rows. if character, column name of EPSG code in DT
#' @param epsgout local projection EPSG code to reproject x_long+y_lat into
#' @param deployment path to deployment CSV. see `check_deployment()`.
#'
#' @return
#' @author Alec L. Robitaille
#' @export
#'
#' @examples
metadata <- function() {
	rbindlist(list(

		# Fogo caribou
		data.table(
			path = '../metadata/data/NL/Fogo-Island/Caribou/Telemetry/FogoCaribou.csv',
			name = 'NL-Fogo-Caribou-Telemetry',
			x_long = 'X_COORD',
			y_lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			datetime = 'datetime',
			extracols = NA,
			tz = 'UTC',
			epsgin = 4326, #TODO: CHECK
			epsgout = 32621
		),

		# NL caribou
		data.table(
			path = '../metadata/data/NL/Provincial/Caribou/Telemetry/AllCaribouDataRaw.csv',
			name = 'NL-Provincial-Caribou-Telemetry',
			x_long = 'X_COORD',
			y_lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			date = 'FIX_DATE',
			time = 'FIX_TIME',
			extracols = list(list('COLLAR_TYPE_CL', 'HERD', 'Map_Quality', 'EPSG_CODE', 'EXCLUDE', 'DOP', 'NAV')),
			tz = 'UTC',
			epsgin = 'EPSG_CODE',
			epsgout = 32621,
			splitBy = 'HERD'
		),

		# NL lynx
		data.table(
			path = '../metadata/data/NL/Provincial/Lynx/Telemetry/Lynx.csv',
			name = 'NL-Provincial-Lynx-Telemetry',
			x_long = 'X_COORD',
			y_lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			date = 'FIX_DATE',
			time = 'FIX_TIME',
			extracols = list(list('COLLAR_TYPE_CL', 'HERD', 'Map_Quality', 'EPSG_CODE', 'EXCLUDE', 'DOP', 'NAV')),
			tz = 'UTC',
			epsgin = 'EPSG_CODE',
			epsgout = 32621,
			splitBy = 'HERD'
		),

		# NL bear
		data.table(
			path = '../metadata/data/NL/Provincial/Bear/Telemetry/Bears.csv',
			name = 'NL-Provincial-Bear-Telemetry',
			x_long = 'X_COORD',
			y_lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			date = 'FIX_DATE',
			time = 'FIX_TIME',
			extracols = list(list('COLLAR_TYPE_CL', 'HERD', 'Map_Quality', 'EPSG_CODE', 'EXCLUDE', 'DOP', 'NAV')),
			tz = 'UTC',
			epsgin = 'EPSG_CODE',
			epsgout = 32621,
			splitBy = 'HERD'
		),

		# NL coyote
		data.table(
			path = '../metadata/data/NL/Provincial/Coyote/Telemetry/Coyote.csv',
			name = 'NL-Provincial-Coyote-Telemetry',
			x_long = 'X_COORD',
			y_lat = 'Y_COORD',
			id = 'ANIMAL_ID',
			date = 'FIX_DATE',
			time = 'FIX_TIME',
			extracols = list(list('COLLAR_TYPE_CL', 'HERD', 'Map_Quality', 'EPSG_CODE', 'EXCLUDE', 'DOP', 'NAV')),
			tz = 'UTC',
			epsgin = 'EPSG_CODE',
			epsgout = 32621,
			splitBy = 'HERD'
		),

		# Vita elk (Lotek)
		data.table(
			path = 'input/vita_elk_lotek_feb_2016-july_2019.csv',
			name = 'MB-Vita-Elk-Telemetry_Lotek',
			x_long = 'long',
			y_lat = 'lat',
			id = 'animal_ID',
			datetime = 'time_utc',
			extracols = c('status'),
			deployment = 'input/vita-elk-lotek-deployment.csv',
			tz = 'UTC',
			epsgin = 4326,
			epsgout = 32614 # Zone 14N
		),

		# Vita elk (Vectronic)
		data.table(
			path = 'input/vita_elk_vectronic_feb_2019-march_2021.csv',
			name = 'MB-Vita-Elk-Telemetry_Vectronic',
			x_long = 'long',
			y_lat = 'lat',
			id = 'animal_ID',
			datetime = 'time_utc',
			extracols = c('status'),
			deployment = 'input/vita-elk-vectronic-deployment.csv',
			tz = 'UTC',
			epsgin = 4326,
			epsgout = 32614 #Zone 14N
		),

		# RMNP elk
		data.table(
			path = '../metadata/data/MB/RMNP/Elk/Telemetry/MB_RMNP_Elk_Telemetry.csv',
			name = 'MB-RMNP-Elk-Telemetry',
			x_long = 'long',
			y_lat = 'lat',
			id = 'ElkID',
			datetime = 'date_time',
			extracols = NA,
			tz = 'GMT', # TODO: triple check
			epsgin = 4326,
			epsgout = 32614
		),

		# RMNP wolf
		data.table(
			path = '../metadata/data/MB/RMNP/Wolf/Telemetry/MB_RMNP_Wolf_Telemetry.csv',
			name = 'MB-RMNP-Wolf-Telemetry',
			x_long = 'longitude',
			y_lat = 'latitude',
			id = 'wolfid',
			date = 'gmtdate', # TODO: not available for all collars, date is presumably UTC-5/-6 or switching CDT/CST
			time = 'gmttime',
			extracols = 'Fix2d3d', # TODO: handle these
			tz = 'GMT',
			epsgin = 4326,
			epsgout = 32614
		)
	),
	fill = TRUE)

	# TODO: if movebank then dir() paths and fill NAs once
}


