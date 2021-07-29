library(sf)
library(data.table)

vita_lotek <- fread('input/vita_elk_lotek_feb_2016-july_2019.csv')
vita_vec <- fread('input/vita_elk_vectronic_feb_2019-march_2021.csv')


# why separated lotek and vectronic
# EPSG out?
rmnp <- fread('input/RMNPdata2006-2015CleanedLN.csv')
fwrite(rmnp, 'input/rmnp_elk_2006_2015.csv')
