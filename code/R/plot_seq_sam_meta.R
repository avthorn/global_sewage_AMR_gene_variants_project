library(tidyverse)


meta <- read_tsv(file = "data/vh_results/sequence_sample_metadata.tsv", col_names = FALSE) %>% 
  rename(
    id = X1,
    num_samples = X2,
    sample_list = X3
  ) %>% 
  mutate(type = case_when(str_ends(id, "R") ~ "Reference",
                          str_ends(id, "R", negate = TRUE) ~ "Variant") )




ggplot(meta) +
  geom_col(aes(x=reorder(id, -num_samples), y= num_samples)) +
  facet_wrap(~type)