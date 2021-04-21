## gs2_metadata.txt
Metadata in tsv format for all samples currently considered eligible in GSII analysis.
https://bitbucket.org/genomicepidemiology/globalsewage/raw/ecaca6615ba326c27ff3e6d329668c7a4b69a614/metadata/sample_metadata/gs2_metadata.txt

## world_bank.csv
Country metadatafile in csv format. Key is country 3 letter code.
https://bitbucket.org/genomicepidemiology/globalsewage/raw/ecaca6615ba326c27ff3e6d329668c7a4b69a614/metadata/world_bank.csv

## ResFinder.phenotype
AMR phenotypes for the genes in ResFinder database.
https://bitbucket.org/genomicepidemiology/globalsewage/raw/ecaca6615ba326c27ff3e6d329668c7a4b69a614/metadata/gene_metadata/ResFinder.phenotype 

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
