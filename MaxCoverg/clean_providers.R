library(tidyverse)
library(sf)
library(mapview)


load(file = here::here("data-raw", "StrategyLocations.rda"))
load(file = here::here("data-raw", "Locations_PracticeProviders.rda"))


Combo <- bind_rows(StrategyLoc_sf %>% select(geometry, name = ORG_ORG, AffiliationCD),
                   THNLoc_sf %>% select(geometry, name = GroupNM, AffiliationCD))

LocXY <-  Combo %>% 
  st_coordinates() %>% 
  as_tibble() %>%
  mutate(id = row_number())


CurrentOffices <- 
  Combo %>% 
  mutate(id = row_number()) %>% 
  left_join(.,
            LocXY, by = c("id")) %>% 
  select(-id) %>% 
  rename(long = X,
         lat = Y) %>% 
  mutate(Affli_Group = case_when(AffiliationCD %in% c("CHMG", "CHC") ~ "Cone",
                                 TRUE ~ "Non Cone")) %>% 
  st_drop_geometry() %>% 
  distinct(Affli_Group, name, long, lat) %>%
  ungroup() %>% 
  group_by_at(vars(-name)) %>% 
  summarise(GroupedEth = toString(name)) %>% 
  ungroup()


save(CurrentOffices, file = here::here("data", "CurrentOffices.rda"))
