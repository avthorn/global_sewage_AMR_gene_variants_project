library(tidyverse)
library(ggtree)
library(treeio)
library(tidytree)
library(ggnewscale)
library(patchwork)



clus = "1"


tree <- read.newick(paste0("data/vh_results/cluster_trees/", clus, ".tree"), node.label = "label")

gene_name_conversion <- read_tsv(file = "data/vh_results/gene_name_conversion.tsv", col_names = FALSE) %>% 
  rename(
    original_gene_name = X1,
    new_gene_name = X2)

country_info_meta <- read_csv(file = paste0("data/post_processing/cluster_country_meta/", clus, "_country_meta.csv")) %>% 
  mutate(across(where(is.character), ~na_if(., "*"))) %>% 
  rename(
    new_gene_name = gene) %>% 
  left_join(.,  gene_name_conversion) %>% 
  relocate(id, original_gene_name)


sample_count <- read_tsv(file = paste0("data/vh_results/cluster_meta/", clus, ".tsv"), col_names = FALSE) %>% 
  select(X1, X2) %>% 
  rename(
    id = X1,
    s_count = X2)


f = fortify(tree)
s = subset(f, isTip)
tip_list = with(s, label[order(y, decreasing=T)])


snp_dist <- read_tsv(file = paste0("data/vh_results/cluster_snp_dist/", clus, ".tsv"), col_names = TRUE) %>% 
  rename(
    id = "snp-dists 0.7.0") %>% 
  column_to_rownames(., var = "id") %>% 
  relocate(all_of(tip_list))




country_meta <- country_info_meta %>%
  column_to_rownames(., var = "id") %>%
  select(-new_gene_name, -original_gene_name, -type, -version) #%>% 




info <- country_info_meta %>%
  select(id, original_gene_name, type, version) #%>% 
#  mutate(version = case_when(str_length(version) == 1 ~ paste0("00", version),
#                             str_length(version) == 2 ~ paste0("0", version),
#                             str_length(version) == 3 ~ version) )




tree_plot <- ggtree(tree) %<+% info + geom_tippoint(size=5, aes(color=original_gene_name)) +
#  theme(legend.position="bottom") + 
  geom_point2(aes(subset=(type=="R")), size=2) +
  theme_tree2() +
  theme(legend.position="right") 


tree_plot_tip <- tree_plot +  geom_tiplab(align=TRUE, linesize=.5, hjust = 0, size =2)

unrooted_tree_plot <- ggtree(tree, layout ="daylight") %<+% info + geom_tippoint(size=5, aes(color=original_gene_name)) +
  #  theme(legend.position="bottom") + 
  geom_point2(aes(subset=(type=="R")), size=2) +
  theme_tree2() +
  theme(legend.position="none") #+
#  geom_tiplab(aes(label= paste0(version)), geom = "label", align=FALSE, linesize=.5, hjust = 0, size =2)
print(tree_plot2)





cols = rainbow(ncol(country_meta), s=.6, v=.9)[sample(1:ncol(country_meta),ncol(country_meta))]

#cols[1] <- "#ffffff"
tree_country_plot <- gheatmap(tree_plot_tip, 
         country_meta, 
         offset = 0.005, 
         width = 1,
         color = "black",
         colnames = TRUE, 
         colnames_position = "bottom",
         colnames_angle = 90,
         colnames_level = NULL, font.size = 2) +
  scale_fill_manual(values=cols) +
  guides(fill=FALSE) +
  theme(legend.position="top") +
  ggtitle(paste0("Cluster ", clus))


print(tree_country_plot)





tree_country_plot/sample_count_plot



dist_plot <- gheatmap(tree_plot, snp_dist, offset=0, width=1, colnames = FALSE, low = "white", high = "midnight blue", color = "black") +
#  guides(fill=FALSE) +
  guides(color = FALSE)
  theme(legend.position="right") + 
print(dist_plot)


sample_count_plot <- tree_plot +  
  geom_facet(panel = "Samples", data = sample_count, geom = ggstance::geom_barh, 
             aes(x = s_count, color = "black", fill = "black"), 
             stat = "identity", width = .6) +
  theme_tree2(legend.position="none")

#print(sample_count_plot)

#tree_country_plot/(sample_count_plot + dist_plot)

#ggsave(file = paste0("debug/", "tree_", clus, ".png"  ), 
#       plot = tree_country_plot, 
#       width = 6.77, 
#       height = 2.83)



cols <- c("black", "blue")

snp_sample_plot <- dist_plot +  
  new_scale_fill() +
#  new_scale_color() +
  geom_facet(panel = "Samples", data = sample_count, geom = ggstance::geom_barh, 
             aes(x = s_count, fill=type), 
             stat = "identity", width = .8) +
  scale_fill_manual(values=cols) +
  theme_tree2(legend.position="right") + 
  theme(strip.background = element_blank(), strip.text = element_blank())




multi_plot <- tree_country_plot/(unrooted_tree_plot + snp_sample_plot)


print(multi_plot)



ggsave(file = paste0("debug/", "tree_", clus, ".png"  ), 
       plot = multi_plot, 
       width = 27, 
       height = 18)
