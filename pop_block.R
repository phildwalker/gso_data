library(tidyverse)
library(tidycensus)
# library(censusapi)


guil_pop <- get_decennial(
  state = "NC", 
  county = "Guilford", 
  geography = "block", 
  variables = "P001001",
  geometry = TRUE
  )

class(guil_pop)

# P001001 # total population
# acs_main <- getCensus(name = "sf1",
#                       vintage = 2010,
#                       vars = c("NAME", "P001001"), 
#                       region = "block:*",
#                       regionin = "state:37+county:081")

mapview::mapview(guil_pop, zcol = "value")

library(sf)

guil_centPT <-
  guil_pop %>% 
  mutate(lon = map_dbl(geometry, ~st_point_on_surface(.x)[[1]]),
         lat = map_dbl(geometry, ~st_point_on_surface(.x)[[2]]))

guil_centPT %>% 
ggplot() +
  geom_sf(fill = "orange") +
  geom_point(aes(x = lon, y = lat),alpha=0.5)+
  # geom_jitter(aes(x = lon, y = lat),color="grey50", alpha=0.3)+
  theme_void()


guil_centPT <-
  guil_centPT %>% 
  mutate(PopIncr = floor(value * 1.1))



sum(guil_centPT$PopIncr)



guil_cent_rep <- guil_centPT[rep(seq(nrow(guil_centPT)), guil_centPT$PopIncr),]



# guil_cent_rep <- st_transform(guil_cent_rep, 3358)
# 
# guil_cent_jittered <- st_jitter(guil_cent_rep, amount = 10)
# 
# 
# guil_cent_rep %>% 
#   ggplot() +
#   geom_sf(fill = "orange") +
#   geom_jitter(aes(x = lon, y = lat),alpha=0.5)+
#   # geom_jitter(aes(x = lon, y = lat),color="grey50", alpha=0.3)+
#   theme_void()
# 
# 
# 
# 
# sum(guil_centPT$value)



save(guil_cent_rep ,file = here::here("guil_cent_rep.rda"))

