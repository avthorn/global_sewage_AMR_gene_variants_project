## gs2_metadata.txt
Metadata in tsv format for all samples currently considered eligible in GSII analysis.
https://bitbucket.org/genomicepidemiology/globalsewage/raw/ecaca6615ba326c27ff3e6d329668c7a4b69a614/metadata/sample_metadata/gs2_metadata.txt

## world_bank.csv
Country metadatafile in csv format. Key is country 3 letter code.
https://bitbucket.org/genomicepidemiology/globalsewage/raw/ecaca6615ba326c27ff3e6d329668c7a4b69a614/metadata/world_bank.csv

## ResFinder.phenotype
AMR phenotypes for the genes in ResFinder database.
https://bitbucket.org/genomicepidemiology/globalsewage/raw/ecaca6615ba326c27ff3e6d329668c7a4b69a614/metadata/gene_metadata/ResFinder.phenotype 

## input_for_VariantHunter/gs2_sample_names.txt
List of sample names from the gs2 dataset. Used as input to VariantHunter.
cat gs2_metadata.txt | cut  -f2 > gs2_sample_names.txt

## input_for_VariantHunter/ResFinder_20200125
Reference genome for VariantHunter analysis. Located on Computerome
/home/databases/metagenomics/db/ResFinder_20200125/ResFinder
