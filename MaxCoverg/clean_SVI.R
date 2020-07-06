library(tidyverse)
library(sf)
library(mapview)

load(file = here::here("data-raw", "SVI_sf.rda"))


SVI <- 
  SVI_sf %>% 
  select(GEOID, NAME, PCT, geometry) %>% 
  separate(NAME, into = c("Block Group", "Tract", "County", "State"), sep = ", ")
