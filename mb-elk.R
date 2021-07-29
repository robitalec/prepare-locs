library(sf)
library(data.table)

vita_lotek <- readRDS('input/elk-data/vita_elk_lotek_feb_2016-july_2019_cleaned.rds')

DT <- st_drop_geometry(vita_lotek)
setDT(DT)

fwrite(DT, 'input/vita_elk_lotek.csv')

vita_vec <- readRDS('input/elk-data/vita_elk_vectronic_feb_2019-march_2021_cleaned.rds')

DT <- st_drop_geometry(vita_vec)
setDT(DT)

fwrite(DT, 'input/vita_elk_vectronic.csv')


# why separated lotek and vectronic
# EPSG out?

rmnp <- fread('input/elk-data/RMNPdata2006-2015CleanedLN.csv')
fwrite(rmnp, 'input/rmnp_elk.csv')
