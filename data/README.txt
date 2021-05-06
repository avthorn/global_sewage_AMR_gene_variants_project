
## VariantHunter_input/gs2_sample_names.txt
List of sample names from the gs2 dataset.
Command:
cat gs2_metadata.txt | cut  -f2 | tail -n +2 > VariantHunter_input/gs2_sample_names.txt

## VariantHunter_input/gs2_sample_names_exclude_62.txt
List of sample names from the gs2 dataset. Sample 62 is excluded since it results in a minor error code when run through kma.
Command:
grep -v 'DTU_2016_62_'  gs2_sample_names.txt > gs2_sample_names_exclude_62.txt




## VariantHunter_input/ResFinder_20200125
Reference genome for VariantHunter analysis. 
Path on Computerome:
/home/databases/metagenomics/db/ResFinder_20200125/ResFinder
