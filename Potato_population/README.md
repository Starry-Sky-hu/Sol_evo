

# Pipeline
Potato population call variants pipeline
1. raw_data_filter.sh
2. HaplotypeCaller.sh
3. gvcf_merge.sh
4. GATK_hardfilter.sh
5. vcftools_filter.sh
6. genotype_freq.sh

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
### genotype_freq.sh
calculate heterozygosity rate by vcf_stat.java
### vcf_stat.java
java script of calculate heterozygosity rate
