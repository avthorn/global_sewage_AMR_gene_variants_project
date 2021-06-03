library(tidyverse)

world_bank <- read_csv(file = "data/raw/countries_regions.csv", col_names = TRUE) %>% 
  rename(
    country3 = "alpha-3") %>% 
  select(region, name, country3) %>% 
  add_row(country3 = "RKS", region = "Europe", name = "Kosovo") %>% 
  add_row(country3 = "NEG", region = "Negative Control", name = "Negative Control") %>%
  arrange(country3)


all_seq_country_meta <- read_csv(file = "data/post_processing/all_seq_country_meta.csv", col_names = TRUE) 

country_col <- all_seq_country_meta %>%  
  select(-id, -gene, -type, -version) %>% 
  pivot_longer(
  .,
  cols=everything(),
  names_to = "country",
  values_to = "binary",
  values_drop_na = FALSE
) %>% 
  rename(
    country3 = "country") %>% 
  select(country3) %>% 
  distinct()

world_region_table <- country_col %>%  left_join(world_bank)


write_csv(x = world_region_table,
          file = "results/world_region_table.csv")
 

