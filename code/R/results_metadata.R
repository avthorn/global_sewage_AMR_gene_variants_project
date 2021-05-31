library(tidyverse)

seq_id_clus <- read_tsv(file = "data/post_processing/seq_id_clus.tsv", col_names = FALSE) %>% 
  rename(
    id = X1,
    cluster_name = X2)


seq_sample_meta <- read_tsv(file = "data/vh_results/sequence_sample_metadata.tsv", col_names = FALSE) %>% 
  rename(
    id = X1,
    sample_count = X2,
    sample_list = X3) 


seq_country <- read_csv(file = "data/post_processing/all_seq_country_meta.csv", col_names = TRUE) 


template_meta <- read_tsv(file = "data/vh_results/template_metadata.tsv", col_names = FALSE) %>% 
  rename(
    original_gene_name = X1,
    gene = X2,
    ref_cound = X3,
    new_var_count = X4) 

gene_conversion <- template_meta %>% select(original_gene_name, gene)

new_var_count <- template_meta %>% 
  mutate(id = str_c(gene, ".R")) %>% 
  select(-ref_cound) %>% 
  rename(new_variants_found = new_var_count)

combined_meta <- seq_sample_meta %>% 
  left_join(seq_id_clus) %>% 
  left_join(seq_country) %>% 
  left_join(gene_conversion) %>% 
  left_join(new_var_count) %>% 
  select(-version) %>% 
  relocate(id, original_gene_name, cluster_name, gene, type, sample_count, new_variants_found, sample_list) %>% 
  mutate(type = case_when(str_detect(type, "R") ~ "Reference",
                          str_detect(type, "v") ~ "Variant"))


write_tsv(x = combined_meta,
          file = "results/results_metadata.tsv")