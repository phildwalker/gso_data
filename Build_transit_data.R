# Pulling in transit information
# Sun Jun 14 13:20:51 2020 ------------------------------

# Looking for the gtfs data for greensboro
# General Transit Feed Specification (GTFS)

# greensboro >> GTA (Greensboro Transition Authority)/HEAT (Higher Education Area Transit)


# PART (Piedmont Area Regional Transport)
# https://transit.land/feed-registry/operators/o-dnr-piedmontauthorityforregionaltransportation


# With the GTA, we probably mainly care about lines: 21 (yellow), 22 (blue), 23 (green) and 24 (purple)


# https://gis.greensboro-nc.gov/arcgis/rest/services/Transportation/GDOT_EAMStreetSigns_MS/MapServer
#  where street sign is bus stop?

# https://gis.greensboro-nc.gov/arcgis/rest/services/Transportation/GDOT_EAMStreetSigns_MS/MapServer/find


path <- glue::glue("https://gis.greensboro-nc.gov/arcgis/rest/services/Transportation/GDOT_EAMStreetSigns_MS/MapServer/find?searchText=Bus&contains=true&searchFields=SIGNTYPE&layers=0&f=json")

out1 <- jsonlite::fromJSON(readLines(path, warn=F))
attribute_out1 <- out1$results$attributes



current_time <- format(Sys.time(), "%Y%m%d%H%M")

readr::write_csv(attribute_out1, here::here("data", "transit", paste0(current_time,"_BusStop_Signs.csv")))


# Note ---- It looks like we are maxing out records... needs to be corrected


