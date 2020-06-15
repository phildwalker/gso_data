# Pulling in police/ crime information
# Sun Jun 14 13:50:28 2020 ------------------------------

# Daily bulletin link below
# http://p2c.greensboro-nc.gov/dailybulletin.aspx#

# Last 180 days? ... looks like there is a delay...
# http://www.arcgis.com/home/webmap/viewer.html?url=https%3A%2F%2Fgis.greensboro-nc.gov%2Farcgis%2Frest%2Fservices%2FPolice%2F180_Days_Crime_Data_MS%2FMapServer&source=sd

# Beats---
# http://www.arcgis.com/home/webmap/viewer.html?url=https%3A%2F%2Fgis.greensboro-nc.gov%2Farcgis%2Frest%2Fservices%2FPolice%2FNeighborhoodOrientedPolicing_MS%2FMapServer&source=sd


## Should probably just loop though the different NIBRS codes and then append all of the data together.

library(tidyverse)

NIBRS <- tibble::tibble(
  CODE = c("09A", "09B", "09C", "100", "11A", "11B", "11C", "11D", "120", "13A", "13B",
           "13C", "200", "210", "220", "23A", "23B", "23C", "23D", "23E", "23F", "23G",
           "23H", "240", "250", "26A", "26B", "26C", "26D", "26E", "26F", "26G", "270",
           "280", "290", "35A", "35B", "36A", "36B", "370", "39A", "39B", "39C", "39D",
           "40A", "40B", "40C", "510", "520", "64A", "64B", "720", "90A", "90B", "90C",
           "90D", "90E", "90F", "90G", "90H", "90J", "90Z"),
  path = glue::glue("https://gis.greensboro-nc.gov/arcgis/rest/services/Police/180_Days_Crime_Data_MS/MapServer/find?searchText={CODE}&contains=true&searchFields=NIBRS_Code&layers=0&f=json")
  )

# NIBRS$path[2]  

gisExtract <- function(path){
  out <- jsonlite::fromJSON(readLines(path, warn=F))
  out2 <- out$results$attributes
}


NIBRS$path[1:3]

CrimeData <- 
  NIBRS$path %>%  #takes the paths individually
  map_dfr(., ~{
    print(.)
    out <- jsonlite::fromJSON(readLines(., warn=F))
    out2 <- out$results$attributes
  }) #reads in the data, and _dfr combines them together

current_time <- format(Sys.time(), "%Y%m%d%H%M")

readr::write_csv(CrimeData, here::here("data", "police", paste0(current_time,"_180days_Events.csv")))



unique(CrimeData$NIBRS_Code)





# path <- glue::glue("https://gis.greensboro-nc.gov/arcgis/rest/services/Police/180_Days_Crime_Data_MS/MapServer/find?searchText={CODE}&contains=true&searchFields=NIBRS_Code&layers=0&f=json")

# out1 <- jsonlite::fromJSON(readLines(NIBRS$path[10], warn=F))
# attribute_out1 <- out1$results$attributes
# class(attribute_out1)




# Note #------------
#  Still need to translate the X/Y coordinates


