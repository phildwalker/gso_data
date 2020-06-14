# Pulling in some level of traffic information
# ie how busy is the street?
# Sun Jun 14 14:12:48 2020 ------------------------------

# https://greensboro.maps.arcgis.com/apps/webappviewer/index.html?id=996316fcf86e435bbca99cd9739f29d4

# GDOT maintains the Traffic Count Program for all signalized intersections within the Greensboro city limits. Traffic counts are used for a variety of reasons including capacity analyses, traffic studies, signal warrant analyses, and coordinated signal timing plans. Each intersection is counted on a two-year rotation. Intersection turning movement counts are conducted by field surveyors and video monitoring over an 11 to 12-hour period.

# example of study data: http://gis.greensboro-nc.gov/gisimages/TrafficCounts/2019/BATTLEGROUND_AVE_&_FERNWOOD_DR_671795_06-17-2019.pdf

# from the map: GDOT Traffic Counts (Features: 1347, Selected: 1)



# now get county data -----------------------------------------------------
# Go to Arc-GIS Server for Public Map
# Using <https://stackoverflow.com/questions/50161492/how-do-i-scrape-data-from-an-arcgis-online-map>
# 1. paste the map id (in url) into: https://www.arcgis.com/sharing/rest/content/items/---ID HERE----/data 
  #996316fcf86e435bbca99cd9739f29d4
# 2. search of //services.arcgis ... >> Looking for the rest api to pull from

# http://www.arcgis.com/home/webmap/viewer.html?url=https%3A%2F%2Fgis.greensboro-nc.gov%2Farcgis%2Frest%2Fservices%2FTransportation%2FGDOT_TrafficCounts_MS%2FMapServer&source=sd

a <- readLines("https://www.arcgis.com/sharing/rest/content/items/29d286e8aa834f11800e3e6851c78f35/data")
a <- jsonlite::fromJSON(a)

# Find the Map
#a[["operationalLayers"]][["id"]]
#a$operationalLayers$url

# Pull the Data
#b <- jsonlite::fromJSON(readLines("https://www.arcgis.com/sharing/rest/content/items/NCCovid19_1679/data"))

# out <- jsonlite::fromJSON(readLines("https://services.arcgis.com/iFBq2AW9XO0jYYF7/arcgis/rest/services/NCCovid19/FeatureServer/0/query?where=0%3D0&outFields=%2A&f=json"))
out1 <- jsonlite::fromJSON(readLines("https://gis.greensboro-nc.gov/arcgis/rest/services/Transportation/GDOT_TrafficCounts_MS/MapServer/0/query?where=Yearcount%3C2009&outFields=*&f=json", warn=F))
out2 <- jsonlite::fromJSON(readLines("https://gis.greensboro-nc.gov/arcgis/rest/services/Transportation/GDOT_TrafficCounts_MS/MapServer/0/query?where=Yearcount%3E=2009&outFields=*&f=json", warn=F))

attribute_out1 <- out1$features$attributes
attribute_out2 <- out2$features$attributes


attribute_out <- dplyr::bind_rows(out1$features$attributes,
                                  out2$features$attributes)


current_time <- format(Sys.time(), "%Y%m%d%H%M")

readr::write_csv(attribute_out, here::here("data", "traffic", paste0(current_time,"_GSO_Traffic.csv")))


















