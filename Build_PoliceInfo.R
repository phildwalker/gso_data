# Pulling in police/ crime information
# Sun Jun 14 13:50:28 2020 ------------------------------

# Daily bulletin link below
# http://p2c.greensboro-nc.gov/dailybulletin.aspx#

# Last 180 days? ... looks like there is a delay...
# http://www.arcgis.com/home/webmap/viewer.html?url=https%3A%2F%2Fgis.greensboro-nc.gov%2Farcgis%2Frest%2Fservices%2FPolice%2F180_Days_Crime_Data_MS%2FMapServer&source=sd

# Beats---
# http://www.arcgis.com/home/webmap/viewer.html?url=https%3A%2F%2Fgis.greensboro-nc.gov%2Farcgis%2Frest%2Fservices%2FPolice%2FNeighborhoodOrientedPolicing_MS%2FMapServer&source=sd


## Should probably just loop though the different NIBRS codes and then append all of the data together.

out1 <- jsonlite::fromJSON(readLines("https://gis.greensboro-nc.gov/arcgis/rest/services/Police/180_Days_Crime_Data_MS/MapServer/find?searchText=09A&contains=true&searchFields=NIBRS_Code&layers=0&f=json", warn=F))

attribute_out1 <- out1$results$attributes
class(attribute_out1)

# attribute_out <- dplyr::bind_rows(out1$results)



current_time <- format(Sys.time(), "%Y%m%d%H%M")

readr::write_csv(attribute_out1, here::here("data", "police", paste0(current_time,"_180days_Events.csv")))



