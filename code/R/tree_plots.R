library(tidyverse)
library(ggtree)
library(treeio)
library(tidytree)
library(ggnewscale)
library(patchwork)

make_final_plot <- function(clus = "clus") {
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
    relocate(id, original_gene_name) %>% 
    mutate(type = case_when(str_detect(type, "R") ~ "Reference",
                            str_detect(type, "v") ~ "Variant"))
  
  sample_count <- read_tsv(file = paste0("data/vh_results/cluster_meta/", clus, ".tsv"), col_names = FALSE) %>% 
    select(X1, X2) %>% 
    rename(
      id = X1,
      s_count = X2)
  
  s = subset(fortify(tree), isTip)
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
    select(id, original_gene_name, type, version) 
  
  ## Make trees #################################
  
  tree_plot <- ggtree(tree) %<+% info + geom_tippoint(size=5, aes(color=original_gene_name)) +
    geom_point2(aes(subset=(type=="Reference")), size=2) +
    theme(legend.position="right") 
  
  
  tree_plot_tip <- tree_plot +  geom_tiplab(align=TRUE, linesize=.5, hjust = 0, size =2) +
    scale_x_continuous(expand = c(.17, 0))
  
  unrooted_tree_plot <- ggtree(tree, layout ="daylight") %<+% info + geom_tippoint(size=5, aes(color=original_gene_name)) +
    geom_point2(aes(subset=(type=="Reference")), size=2) +
    ggtitle("Unrooted View") +
    theme(legend.position="none")

  ## Make subplots #################################
  
  
  # Calculate offset
  find_plot_x_limits <- function(plot) {
    b = ggplot_build(plot)
    xmin = b$layout$panel_params[[1]]$x.range[1]
    xmax = b$layout$panel_params[[1]]$x.range[2]
    list(xmin = xmin, xmax = xmax)
  }
  
  off = (find_plot_x_limits(tree_plot_tip)$xmax - max(tree_plot_tip[["data"]][["x"]])) * 1.5
  
  # Find colors
  cols_country = rainbow(ncol(country_meta), s=.6, v=.9)[sample(1:ncol(country_meta),ncol(country_meta))]
  
  # Make country subplot
  tree_country_plot <- gheatmap(tree_plot_tip, 
                                country_meta, 
                                offset = off, 
                                width = 2,
                                color = "black",
                                colnames = TRUE, 
                                colnames_position = "bottom",
                                colnames_angle = 90,
                                colnames_level = NULL, font.size = 2) +
    scale_fill_manual(values=cols_country) +
    guides(fill=FALSE) +
    ggtitle("Fastree tree and heatmap of sampling countries") +
    theme(legend.position="top",
          plot.title = element_text(hjust = 0.5))
  
  
  dist_plot <- gheatmap(tree_plot, 
                        snp_dist, 
                        offset=0, 
                        width=1, 
                        colnames = FALSE, 
                        low = "white", 
                        high = "midnight blue", 
                        color = "black") +
    guides(color = FALSE) +
    ggtitle("SNV distance") +
    theme(legend.position="right", plot.title = element_text(hjust = 0.35)) 
  
  
  snp_sample_plot <- dist_plot +  
    new_scale_fill() +
    geom_facet(panel = "Number of samples", data = sample_count, geom = ggstance::geom_barh, 
               aes(x = s_count, fill=type), 
               stat = "identity", width = .8) +
    scale_fill_manual(values=c("black", "blue")) +
    theme_tree2() +
    theme(legend.position="bottom") 
  
  
  ## Save full plot #############################
  
  combined_plot <- tree_country_plot/(unrooted_tree_plot + snp_sample_plot)
  
  final_plot <- combined_plot + plot_annotation(
    title = paste0("Cluster ", clus),
    subtitle = '',
    caption = '',
    theme = theme(plot.title = element_text(size = 40))
  )
  
  
  
  ggsave(file = paste0("results/cluster_tree_plots/", clus, "_tree", ".png"), 
         plot = final_plot, 
         width = 21, 
         height = 14)
  
}


cluster_names <- dir(path = "data/vh_results/cluster_trees", 
                     pattern = "*.tree", 
                     full.names = F) %>% 
  str_extract(., "[:digit:]+") 
  
  

for(cluster in cluster_names) {

  make_final_plot(cluster)
}

