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


details <- rbindlist(list(
	data.table(
		path = '../fogo-caribou/data/FogoCaribou.csv',
		id = 'ANIMAL_ID',
		datetime = 'datetime',
		xcoord = 'X_COORD',
		ycoord = 'Y_COORD',
		extracols = NA,
		tz = grep('Newfoundland', OlsonNames(), value = TRUE),
		epsg = 32621
	)
))

