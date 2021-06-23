# data.table(
# 	path = ,
# 	id = ,
# 	datetime = ,
# 	x = ,
# 	y = ,
# 	extracols ,
# 	tz = ,
# 	epsg =
# )

data_details <- function() {
	rbindlist(list(
		data.table(
			path = '../fogo-caribou/data/FogoCaribou.csv',
			x = 'X_COORD',
			y = 'Y_COORD',
			id = 'ANIMAL_ID',
			datetime = 'datetime',
			extracols = NA,
			tz = grep('Newfoundland', OlsonNames(), value = TRUE),
			epsg = 32621
		),
		data.table(
			path = '../metadata/data/NL/Provincial/Caribou/Telemetry/AllCaribouDataRaw.csv',
			x = 'X_COORD',
			y = 'Y_COORD',
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


