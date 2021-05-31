library(tidyverse)
library(ggtree)
library(treeio)
library(tidytree)
library(ggnewscale)

# Load country meta
country <- read_csv(file = "data/post_processing/all_seq_country_meta.csv", col_names = TRUE) 

samples <- read_tsv(file = "data/vh_results/sequence_sample_metadata.tsv", col_names = FALSE) %>% 
  rename(
    id = X1,
    s_count = X2) %>% 
  select(id, s_count) %>% 
  filter(s_count > 0)  # Filter out those ref sequences found in 0 sampels 

world_bank <- read_csv(file = "data/raw/world_bank.csv", col_names = TRUE) %>% 
  rename(
    country = "Country Code",
    region_name = Region) %>% 
  select(country, region_name) %>% 
  arrange(region_name, country)

c_s <- samples %>% left_join(country) 


make_plot<-function(long_data, title)
{
  cols_regions <- c("white", "deeppink", "cyan3", "darkorange", "dark green",  "brown4", "chartreuse2", "mediumpurple1")
  ggplot(long_data, aes(x = factor(country, levels = world_bank$country), y = fct_reorder(id, gene, .desc = FALSE), fill = Region)) +
    geom_tile(color="gray") +
    scale_fill_manual(values=cols_regions)  +
    xlab("Country") + ylab("Sequence ID") +
    ggtitle(title) + 
    theme(legend.position = "bottom", text = element_text(size=3),
          axis.text.x = element_text(angle=90, size = 3), axis.title=element_text(size=12,face="bold"), 
          plot.title = element_text(size = 15, face = "bold"), legend.text=element_text(size=4), legend.title =element_text(size=10))
}



c_s_long <- c_s %>% 
  select(-version) %>% 
  pivot_longer(
    .,
    cols = c(-id, -s_count, -type, -gene),
    names_to = "country",
    values_to = "Region",
    values_drop_na = FALSE
  )


c_s_long_w <- c_s_long %>% left_join(world_bank) %>% 
  mutate(Region = case_when(Region != "*" ~ region_name,
                             Region == "*" ~ "*"))

c_s_long_w_v <-  c_s_long_w %>% 
  filter(type == "v") 


c_s_long_w_R <-  c_s_long_w %>% 
  filter(type == "R") 

all_plot <- make_plot(c_s_long_w, "Sequences vs sample country")

v_plot <- make_plot(c_s_long_w_v, "Variant sequences vs sample country")

R_plot <- make_plot(c_s_long_w_R, "Reference sequences vs sample country")


ggsave(file = paste0("results/seq_country_plots/all_seqs_country_plot.png"), 
       plot = all_plot, 
       width = 12, 
       height = 36)

ggsave(file = paste0("results/seq_country_plots/variant_seqs_country_plot.png"), 
       plot = v_plot, 
       width = 12, 
       height = 28)

ggsave(file = paste0("results/seq_country_plots/ref_seqs_country_plot.png"), 
       plot = R_plot, 
       width = 12, 
       height = 28)

