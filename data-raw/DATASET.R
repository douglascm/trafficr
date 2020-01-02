library(readr)
library(sf)
library(data.table)

sioux_network <- st_read("data-raw/sioux_falls/network.shp",quiet = T)
sioux_zones <- st_read("data-raw/sioux_falls/zones.shp",quiet = T)
sioux_demand <- fread("data-raw/sioux_falls/demand.csv",stringsAsFactors = F,data.table = T)

usethis::use_data(sioux_network, overwrite = TRUE)
usethis::use_data(sioux_zones, overwrite = TRUE)
usethis::use_data(sioux_demand, overwrite = TRUE)
