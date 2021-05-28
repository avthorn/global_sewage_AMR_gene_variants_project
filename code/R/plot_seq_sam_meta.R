library(tidyverse)
library(reshape2)




meta <- read_tsv(file = "data/vh_results/sequence_sample_metadata.tsv", col_names = FALSE) %>% 
  rename(
    id = X1,
    num_samples = X2,
    sample_list = X3
  ) %>% 
  mutate(type = case_when(str_ends(id, "R") ~ "Reference",
                          str_ends(id, "R", negate = TRUE) ~ "Variant") )

meta_v <- meta %>%  filter(type == "Variant")

country <- read_csv(file = "data/post_processing/all_seq_country_meta.csv", col_names = TRUE) %>% 
  mutate(across(where(is.character), ~na_if(., "*")))




country  %>% count(ALB)

country_long <- country %>% 
  select(-gene, -type, -version) %>% 
  pivot_longer(
    .,
    cols = ALB:ZMB,
    names_to = "country",
    values_to = "present",
    values_drop_na = FALSE
  )

ggplot(country_long, aes(x = country, y = id, fill = present)) +
  geom_tile()

colors <- c("green", "yellow", "red")

ggplot(melt(cbind(sample=rownames(qualityScores), qualityScores)), 
       aes(x = variable, y = sample, fill = factor(value))) + 
  geom_tile() + 
  scale_fill_manual(values=colors)

ggplot(meta) +
  geom_col(aes(x=reorder(id, -num_samples), y= num_samples)) +
  facet_wrap(~type)




# Library
library(ggplot2)

# Dummy data
x <- LETTERS[1:20]
y <- paste0("var", seq(1,20))
data <- expand.grid(X=x, Y=y)
data$Z <- runif(400, 0, 5)

# Heatmap 
ggplot(data, aes(X, Y, fill= Z)) + 
  geom_tile()