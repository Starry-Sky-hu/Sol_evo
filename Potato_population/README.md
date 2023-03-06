

# Pipeline
sh raw_data_filter.sh
sh HaplotypeCaller.sh
sh gvcf_merge.sh
sh GATK_hardfilter.sh
sh vcftools_filter.sh


### raw_data_filter.sh
raw data filter by fastp
### HaplotypeCaller.sh
reads mapping and HaplotypeCaller
### gvcf_merge.sh
gvcf merge
### GATK_hardfilter.sh
GATK hardfilter
### vcftools_filter.sh
vcftools filter, parameter："--minDP 4 --maxDP 100 --minGQ 10 --minQ 30 --max-missing 0.5 --maf 0.001"
### Landrace_187_Add6Accession.txt
ID of all accessions
### tetraploid
call variants pipeline of tetraploid


