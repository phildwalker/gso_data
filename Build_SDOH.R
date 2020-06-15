# Social Determinates of Health
# Sun Jun 14 15:46:50 2020 ------------------------------


# http://www.arcgis.com/home/webmap/viewer.html?url=https://services.arcgis.com/iFBq2AW9XO0jYYF7/ArcGIS/rest/services/NCSocialDeterminants/FeatureServer&source=sd






path <- glue::glue("https://services.arcgis.com/iFBq2AW9XO0jYYF7/ArcGIS/rest/services/NCSocialDeterminants/FeatureServer/5/query?where=FIPS=081&outFields=*&f=json")

out1 <- jsonlite::fromJSON(readLines(path, warn=F))
attribute_out1 <- out1$features$attributes


current_time <- format(Sys.time(), "%Y%m%d%H%M")

readr::write_csv(attribute_out1, here::here("data", "SDOH", paste0(current_time,"_SDOH.csv")))



