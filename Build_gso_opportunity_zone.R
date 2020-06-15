# Pulling in greensboro opportunity zones
# Sun Jun 14 14:08:50 2020 ------------------------------

# https://greensboro.maps.arcgis.com/apps/webappviewer/index.html?id=2f25fa3c676a40199efd80aedb9381b2

# https://gis.greensboro-nc.gov/arcgis/rest/services/

# reinvestment areas >> https://gis.greensboro-nc.gov/arcgis/rest/services/EconomicDevelopment/ReinvestmentOpportunities_MS/MapServer
# budgeted activities >> https://gis.greensboro-nc.gov/arcgis/rest/services/Budget/CIP_MS/MapServer
# >> These are ones already in progress


# Theses are from what they call the opportunity zones ----------------

# https://gis.greensboro-nc.gov/arcgis/rest/services/Planning/AvailableProperties_MS/MapServer

path <- glue::glue("https://gis.greensboro-nc.gov/arcgis/rest/services/Planning/AvailableProperties_MS/MapServer/find?searchText=Yes&contains=true&searchFields=Available_For_Sale&layers=0&f=json")

out1 <- jsonlite::fromJSON(readLines(path, warn=F))
attribute_out1 <- out1$results$attributes



current_time <- format(Sys.time(), "%Y%m%d%H%M")

readr::write_csv(attribute_out1, here::here("data", "opportunity_zone", paste0(current_time,"_AvailableProperties.csv")))

