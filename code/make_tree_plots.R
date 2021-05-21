library(tidyverse)
library(ggtree)
library(treeio)
library(tidytree)

#borovecki_data <- dir(path = "data/raw", 
#                      pattern = "*.tsv", 
#                      full.names = T) %>%
#  map(read_tsv) %>%
#  reduce(inner_join, 
#         by = "ID_REF")


tree <- read.newick("data/VH_output/5_results/cluster_trees/1.tree", node.label = "label")
metadata <- read_csv(file = "data/tree_meta_data/1_tree_meta.csv")


meta_country <- metadata %>%
  column_to_rownames(., var = "id") %>%
  #  select(where(is.numeric))
  select(-gene, -type, -version)

info <- metadata %>%
  select(id, gene, type, version)

#cols <- c("R" = "black", "v" = "white")

p <- ggtree(tree) %<+% info + geom_tippoint(size=3, aes(color=gene)) +
  theme(legend.position="bottom") + 
  geom_point2(aes(subset=(type=="R")), size=1) +
  geom_tiplab(aes(label=paste0(version)), align=TRUE, linesize=.5, hjust = 3) + 
  theme_tree2()



#  theme(legend.position="bottom")


cols = rainbow(nrow(metadata), s=.6, v=.9)[sample(1:nrow(metadata),nrow(metadata))]
gheatmap(p, 
         meta_country, 
         offset = 0, 
         width = 0.5,
         color = "black",
         colnames = TRUE, 
         colnames_position = "bottom", 
         colnames_level = NULL, font.size = 2) +
  scale_fill_manual(values=cols) +
  guides(fill=FALSE)

gheatmap(p, 
         meta_country, 
         offset = 0.005, 
         width = 0.6,
         color = "black",
         colnames = TRUE, 
         colnames_position = "bottom", 
         colnames_level = NULL, font.size = 2) +
  scale_fill_manual(breaks=c("y", "n"), 
                    values=c("steelblue", "white"), name="Location")


gheatmap(p, 
         meta_country, 
         offset = 0.005, 
         width = 0.6,
         color = "black",
         colnames = TRUE, 
         colnames_position = "bottom", 
         colnames_level = NULL, font.size = 2) +
  scale_fill_viridis_d(option="D", name="discrete\nvalue")




#p + scale_fill_manual(values=cols)

