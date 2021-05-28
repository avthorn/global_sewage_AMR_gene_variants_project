library(tidyverse)

# Load country meta
country <- read_csv(file = "data/post_processing/all_seq_country_meta.csv", col_names = TRUE) #%>% 
  #mutate(across(where(is.character), ~na_if(., "*")))

samples <- read_tsv(file = "data/vh_results/sequence_sample_metadata.tsv", col_names = FALSE) %>% 
  rename(
    id = X1,
    s_count = X2) %>% 
  select(id, s_count) %>% 
  filter(s_count > 0)  # Filter out those ref sequences found in 0 sampels 

world_bank <- read_csv(file = "data/raw/world_bank.csv", col_names = TRUE) %>% 
  rename(
    country = "Country Code",
    region = Region) %>% 
  select(country, region) %>% 
  arrange(region, country)



c_s <- samples %>% left_join(country) 



c_s_long <- c_s %>% 
  select(-version) %>% 
  pivot_longer(
    .,
    cols = c(-id, -s_count, -type, -gene),
    names_to = "country",
    values_to = "present",
    values_drop_na = FALSE
  )


c_s_long_w <- c_s_long %>% left_join(world_bank) %>% 
  mutate(present = case_when(present != "*" ~ region,
                             present == "*" ~ "*"))

#factor(c_s_long$country, levels = world_bank$country)


#levels = c("b", "c", "d", "a")
# Find colors
num_countries <- c_s %>%  select(-gene, -type, -version, -s_count, -id) %>%  ncol()

cols_country = rainbow(num_countries, s=.6, v=.9)[sample(1:num_countries,num_countries)]

# append white color to the beginning of the list.
cols_all <- "#ffffff"  %>%  append(cols_country)

cols_regions <- c("white", "pink", "dark blue", "orange", "light green", "red", "light blue", "dark green")


# all plot
ggplot(c_s_long_w, aes(x = factor(country, levels = world_bank$country), y = fct_reorder(id, gene, .desc = FALSE), fill = present)) +
  geom_tile() +
  scale_fill_manual(values=cols_regions) +
  theme(legend.position = "none")


c_s_long_w_v <-  c_s_long_w %>% 
  filter(type == "v") #%>% 
#  mutate(across(where(is.character), ~na_if(., "*"))) %>% 
#  select_if(~sum(!is.na(.)) > 0)


#df %>% select_if(~sum(!is.na(.)) > 0)

ggplot(c_s_long_w_v, aes(x = factor(country, levels = world_bank$country), y = fct_reorder(id, id, .desc = FALSE), fill = present)) +
  geom_tile(color="black") +
  scale_fill_manual(values=cols_regions) +
  theme(legend.position = "bottom")

# fct_reorder(id, gene)