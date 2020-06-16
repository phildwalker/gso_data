# Pulling in parcel information to capture what places are available
# Sun Jun 14 13:20:00 2020 ------------------------------

# NC onemap 
# 

# master address data
# https://www.nconemap.gov/datasets/nc-master-address-dataset-2014?geometry=-79.808%2C36.088%2C-79.786%2C36.091&showData=true

# GSO oarcgis
# http://www.arcgis.com/home/webmap/viewer.html?url=https%3A%2F%2Fgis.greensboro-nc.gov%2Farcgis%2Frest%2Fservices%2FPlanning%2FParcels_Ownership_Census_MyGov%2FMapServer&source=sd

# GSO building inspection information
# https://gis.greensboro-nc.gov/arcgis/rest/services/EngineeringInspections/BImap_MS/MapServer/10

# https://gis.greensboro-nc.gov/arcgis/rest/services/GISDivision/CityCountyBldgs_MS/MapServer

# BImap MS - Parcels (Features: 213726, Selected: 1)

library(tidyverse)

rowsAMT <- 213726
binsize <- 500

bincount <- ceiling(rowsAMT/ binsize)

buckets <- tibble::tibble(
  order = 0:bincount,
  START = order*binsize,
  END = START+binsize,
  path = glue::glue("https://gis.greensboro-nc.gov/arcgis/rest/services/EngineeringInspections/BImap_MS/MapServer/10/query?where=OBJECTID%3E={START}%20AND%20OBJECTID%3C{END}&outFields=*&f=json")
  )


buckets$path[1]


parcel_dat <- 
  buckets$path %>%  #takes the paths individually
  map_dfr(., ~{
    print(.)
    out <- jsonlite::fromJSON(readLines(., warn=F))
    out2 <- out$features$attributes
  }) #reads in the data, and _dfr combines them together


parcel_group1 <- parcel_dat[1:10000]

save(parcel_dat, file = here::here("data", "parcels", "parcel_info.rda"))


# current_time <- format(Sys.time(), "%Y%m%d%H%M")
# readr::write_csv(parcel_dat, here::here("data", "parcels", paste0(current_time,"_parcel_info.csv")))

# out1 <- jsonlite::fromJSON(readLines("https://gis.greensboro-nc.gov/arcgis/rest/services/EngineeringInspections/BImap_MS/MapServer/10/query?where=OBJECTID%3E=1000%20AND%20OBJECTID%3C1500&outFields=*&f=json", warn=F))

# &geometryType=esriGeometryPoint
# esriGeometryPoint
# esriGeometryPolygon

# out2 <- out1$features$attributes
# out_geo <- out1$features$geometry







