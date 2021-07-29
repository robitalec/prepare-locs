library(sf)
library(data.table)

vita_lotek <- fread('input/vita_elk_lotek_feb_2016-july_2019.csv')
vita_vec <- fread('input/raw/vita_elk_vectronic_feb_2019-march_2021.csv')

deploy <- fread('input/raw/collar_deployment_data.csv')
setnames(deploy, c('animal_ID', 'deploy_date', 'retrieve_date'), c('id', 'start_date', 'end_date'))
fwrite(deploy[tag_type == 'lotek', .(id, start_date, end_date)], 'input/vita-elk-lotek-deployment.csv')

vita_vec[deploy[tag_type == 'vectronic'],
				 animal_ID := animal_ID,
				 on = 'collar_ID']
fwrite(vita_vec, 'input/vita_elk_vectronic_feb_2019-march_2021.csv')

vita_vec[deploy, on = .(id, datetime >= deploy_date)]
merge(vita_vec,
			deploy,
			by = c('animal_ID', ''))
vita_vec[]


# why separated lotek and vectronic
# EPSG out?
rmnp <- fread('input/RMNPdata2006-2015CleanedLN.csv')
rmnp[, (c('long', 'lat')) :=
	 	data.table::as.data.table(
	 		sf::sf_project(
	 			pts = as.matrix(.SD, ncol = 2),
	 			from = sf::st_crs(as.numeric(32614)),
	 			keep = TRUE,
	 			to = sf::st_crs(4326))
	 	),
	 .SDcols = c('X', 'Y')]



fwrite(rmnp, 'input/RMNP_elk_2006_2015.csv')
