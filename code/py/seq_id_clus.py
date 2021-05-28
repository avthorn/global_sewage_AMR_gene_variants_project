import os

seq_id_clus = open("../../data/post_processing/seq_id_clus.tsv","w")

directory = os.fsencode("../../data/vh_results/cluster_meta/")
    
for file in os.listdir(directory):
    cluster_meta_filename = os.fsdecode(file)
    cluster_name = cluster_meta_filename.split(".")[0]
    infile_path = "../../data/vh_results/cluster_meta/" + cluster_meta_filename  
    cluster_meta = open(infile_path,"r")

    for line in cluster_meta:
        line = line.strip()
        variant_id = line.split("\t")[0]
        if not variant_id.endswith(".R"):
            out_str = variant_id + "\t" + cluster_name
            print(out_str, file = seq_id_clus)
    cluster_meta.close()


seq_id_clus.close()
