# data.table(
# 	path = ,
# 	id = ,
# 	datetime = ,
# 	xcoord = ,
# 	ycoord = ,
# 	extracols ,
# 	tz = ,
# 	epsg =
# )

data_details <- function() {
	rbindlist(list(
		data.table(
			path = '../fogo-caribou/data/FogoCaribou.csv',
			id = 'ANIMAL_ID',
			datetime = 'datetime',
			xcoord = 'X_COORD',
			ycoord = 'Y_COORD',
			extracols = NA,
			tz = grep('Newfoundland', OlsonNames(), value = TRUE),
			epsg = 32621
		),
		data.table(
			path = 'input/AllCaribouDataRaw.csv',
			id = 'ANIMAL_ID',
			datetime = list(list('FIX_DATE', 'FIX_TIME')),
			xcoord = 'X_COORD',
			ycoord = 'Y_COORD',
			extracols = list(list('HERD', 'Map_Quality', 'LOCQUAL')),
			tz = grep('Newfoundland', OlsonNames(), value = TRUE),
			epsg = 32621
		)
	))
}


