# from: https://github.com/yonghah/esri2sf


urltest <- "https://gis.greensboro-nc.gov/arcgis/rest/services/EngineeringInspections/BImap_MS/MapServer/10/query?where=OBJECTID%3E=1%20AND%20OBJECTID%3C=10&outFields=*&f=json"

esri2sf(urltest)

url <- urltest


esri2sf <- function(url, geomType=NULL) {
  library(httr)
  library(jsonlite)
  library(sf)
  library(dplyr)
  layerInfo <- jsonlite::fromJSON(
    httr::content(
      httr::POST(
        url,
        encode="form"
      ),
      as="text"
    )
  )
  print(layerInfo$type)
    
  geomType <- layerInfo$geometryType
  print(geomType)

  queryUrl <- urltest
  esriFeatures <- getEsriFeatures(url)
  simpleFeatures <- esri2sfGeom(esriFeatures, geomType)
  return(simpleFeatures)
}

getEsriFeatures <- function(queryUrl) {
  ids <- getObjectIds(queryUrl)
  idSplits <- split(ids, ceiling(seq_along(ids)/500))
  results <- lapply(idSplits, getEsriFeaturesByIds, queryUrl)
  merged <- unlist(results, recursive=FALSE)
  return(merged)
}

getObjectIds <- function(queryUrl){
  # create Simple Features from ArcGIS servers json response
  # responseRaw <- httr::content(
  #   httr::POST(
  #     queryUrl,
  #     encode="form"
  #     ),
  #   as="text"
  # )
  # response <- jsonlite::fromJSON(responseRaw)
  # return(response$features$attributes$objectId)
  return(layerInfo$features$attributes$OBJECTID)
}

getEsriFeaturesByIds <- function(ids, queryUrl){
  # create Simple Features from ArcGIS servers json response
  # query <- list(
  #   objectIds=paste(ids, collapse=","),
  #   outFields=paste(fields, collapse=","),
  #   outSR='4326',
  #   f="json"
  # )
  responseRaw <- httr::content(
    httr::POST(
      queryUrl,
      encode="form"
    ),
    as="text"
  )
  response <- jsonlite::fromJSON(responseRaw,
                                 simplifyDataFrame = FALSE,
                                 simplifyVector = FALSE,
                                 digits=NA)
  esriJsonFeatures <- response$features
  return(esriJsonFeatures)
}

esri2sfGeom <- function(jsonFeats, geomType) {
  # convert esri json to simple feature
  if (geomType == 'esriGeometryPolygon') {
    geoms <- esri2sfPolygon(jsonFeats)
  }
  # attributes
  atts <- lapply(jsonFeats, '[[', 1) %>%
    lapply(function(att) lapply(att, function(x) return(ifelse(is.null(x), NA, x))))
  
  af <- dplyr::bind_rows(lapply(atts, as.data.frame.list, stringsAsFactors=FALSE))
  # geometry + attributes
  df <- sf::st_sf(geoms, af, crs="+init=epsg:2264")
  return(df)
}

# projection: 102719 >> looks like it's the same as crs = "+init=epsg:2264"


esri2sfPolygon <- function(features) {
  ring2matrix <- function(ring) {
    return(do.call(rbind, lapply(ring, unlist)))
  }
  rings2multipoly <- function(rings) {
    return(sf::st_multipolygon(list(lapply(rings, ring2matrix))))
  }
  getGeometry <- function(feature) {
    if(is.null(unlist(feature$geometry$rings))){
      return(sf::st_multipolygon())
    } else {
      return(rings2multipoly(feature$geometry$rings))
    }
  }
  geoms <- sf::st_sfc(lapply(features, getGeometry))
  return(geoms)
}




library(ggplot2)

class(simpleFeatures)

simpleFeatures %>%
  ggplot()+
  geom_sf()



unlist(layerInfo$feature$geometry$rings)


sf::st_multipolygon(list())



polygonMatrix <- do.call(rbind, lapply(layerInfo$feature$geometry$rings[1], unlist))


polygonMatrix <- unlist(layerInfo$feature$geometry$rings[1])

polyList <- list(as.vector(polygonMatrix))
class(polyList)
length(polyList)

all(vapply(polyList, is.list, TRUE))
is.list(polyList)

sf::st_multipolygon(x=polyList)



