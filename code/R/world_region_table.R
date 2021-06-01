library(tidyverse)

world_bank <- read_csv(file = "data/raw/countries_regions.csv", col_names = TRUE) %>% 
  rename(
    country3 = "alpha-3") %>% 
  select(region, name, country3) %>% 
  add_row(country3 = "RKS", region = "Europe", name = "Kosovo") %>% 
  arrange(region, name)

write_csv(x = world_bank,
          file = "results/country_code_look_up.csv")
 

