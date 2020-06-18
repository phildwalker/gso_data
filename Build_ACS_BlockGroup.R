# Pulling in ACS data on the block group levels
# Sun Jun 14 13:23:15 2020 ------------------------------

# Helpful to get a more detailed view than the SVI

library(tidyverse)
library(tidycensus)

allVars <- bind_rows(load_variables(2018, "acs5", cache = TRUE) %>% mutate(DataGroup = "Data"),
                     load_variables(2018, "acs5/profile", cache = TRUE) %>% mutate(DataGroup = "Profile"),
                     load_variables(2018, "acs5/subject", cache = TRUE) %>% mutate(DataGroup = "Subject")
)

Guil_Pop <- get_acs(year = 2018, state = "NC", county = "Guilford",
                    survery = "acs5", 
                    geography = "block group",
                    variables = c(totalPop ="S0601_C01_001"),
                    geometry = F)

Guil_POV <- get_acs(year = 2018, state = "NC", county = "Guilford",
                    survery = "acs5", 
                    geography = "block group",
                    variables = c(Poverty ="B17001_002"),
                    geometry = F)




lookupCodes <- tibble(
  ~ACSlocat,~name, ~SVI_used, ~recreateCode,
  "profile","E_TOTPOP", "S0601_C01_001E", "S0601_C01_001",
  "subject","E_POV", "B17001_002E", "B17001_002"
)

