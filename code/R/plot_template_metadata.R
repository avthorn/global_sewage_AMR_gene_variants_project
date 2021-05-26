library(tidyverse)


template_meta <- read_tsv(file = "data/vh_results/template_metadata.tsv", col_names = FALSE) %>% 
  rename(
    original_id = X1,
    new_id = X2,
    ref_found = X3,
    new_vars = X4
  ) 


template_meta_only_new_var <- template_meta %>% 
  filter(new_vars > 0)

ggplot(template_meta_only_new_var) +
  geom_bar(aes(new_vars))