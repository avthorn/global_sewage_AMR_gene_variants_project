## ResFinder_20200125
Reference genome for VariantHunter analysis.
Path on Computerome:
/home/databases/metagenomics/db/ResFinder_20200125/ResFinder

## gs2_metadata.txt
Metadata in tsv format for all samples currently considered eligible in GSII analysis.
https://bitbucket.org/genomicepidemiology/globalsewage/raw/ecaca6615ba326c27ff3e6d329668c7a4b69a614/metadata/sample_metadata/gs2_metadata.txt


## gs2_sample_names.txt
List of sample names from the gs2 dataset.
Command:
cat gs2_metadata.txt | cut  -f2 | tail -n +2 > VariantHunter_input/gs2_sample_names.txt


## gs2_sample_names_exclude_62.txt
List of sample names from the gs2 dataset. 
Sample 62 is excluded since it results in a minor error code when running kma. This is because DTU_2016_62_2_MG_DEU-27_1_R2.trim.fq.gz has some "trailing garbage"
Command:
grep -v 'DTU_2016_62_'  gs2_sample_names.txt > gs2_sample_names_exclude_62.txt

## world_bank.csv
Country income metadatafile in csv format. Key is country 3 letter code.
https://bitbucket.org/genomicepidemiology/globalsewage/raw/ecaca6615ba326c27ff3e6d329668c7a4b69a614/metadata/world_bank.csv

## ResFinder.class
Antibiotics class and AMR gene name metadata file.
https://bitbucket.org/genomicepidemiology/globalsewage/src/master/metadata/gene_metadata/ResFinder.class 


## countries_regions.csv
Country region lookup file. Downloaded from  Luke Duncalfes git hub.
https://raw.githubusercontent.com/lukes/ISO-3166-Countries-with-Regional-Codes/master/all/all.csv
