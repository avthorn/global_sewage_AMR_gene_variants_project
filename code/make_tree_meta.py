import os


gs2_dict = {}

gs2_meta = open("../data/raw/gs2_metadata.txt","r")

row_count = 0
for row in gs2_meta:
    row_count += 1
    row = row.strip()
    row_list = row.split("\t")
    if row_count > 1:
        name = row_list[1]
        country = row_list[11]
        gs2_dict[name] = country

gs2_meta.close()

directory = os.fsencode("../data/VH_output/5_results/cluster_meta/")
    
for file in os.listdir(directory):
    cluster_meta_filename = os.fsdecode(file)
    cluster_name = cluster_meta_filename.split(".")[0]
    infile_path = "../data/VH_output/5_results/cluster_meta/" + cluster_meta_filename  
    cluster_meta = open(infile_path,"r")

    country_set = set()
    variant_dict = {}
    all_samples_list = []


    for line in cluster_meta:
        line = line.strip()
        variant_id = line.split("\t")[0]
        sample_string = line.split("\t")[2]
        sample_list = sample_string.split(",")
        variant_dict[variant_id] = sample_list
        all_samples_list.extend(sample_list)
    cluster_meta.close()


    for s_id in all_samples_list:
        if s_id !=  "*":
            country_set.add(gs2_dict[s_id])

    country_list = sorted(list(country_set))

    outfile_path = "../data/tree_meta_data/" + cluster_name + "_tree_meta.tsv"

    country_meta = open(outfile_path, "w")
    header = "id, gene, type, version, " + ", ".join(country_list)
    print(header, file = country_meta)

    for v_id in variant_dict.keys():
        gene = v_id.split(".")[0]
        type = v_id.split(".")[1][0]
        version = v_id[-1]

        for sample in variant_dict[v_id]:
            if sample != "*":
                variant_dict[v_id][variant_dict[v_id].index(sample)] = gs2_dict[sample]
        country_string = ""
        for country in country_list:
            if country in variant_dict[v_id]:
                country_string += "y, "
            else:
                country_string += "n, "
        line = v_id + ", " + gene + ", " + type + ", " + version + ", " + country_string.rstrip(", ")
        print(line, file = country_meta)

    country_meta.close() 

