# Calculate heterozygous of RH and RH10-15
1. RH_callSNP.sh
2. RH1015_callSNP.sh
3. RH_RH1015_merge.sh
4. vcf2gbs.sh
5. RH_RH1015_stat.sh


### RH_callSNP.sh
RH minimap2 mapping and bcftools call variant, output both variant and non-variant sites 
### RH1015_callSNP.sh
RH1015 minimap2 mapping and bcftools call variant, output both variant and non-variant sites 
### RH_RH1015_merge.sh
Merge two vcf files
### vcf2gbs.sh
Exclude error sites, and convert vcf format to gbs format using vcf2gbs_chr01.R
### RH_RH1015_stat.sh
Calculate heterozygous using sliding_vcf_stat.R
### vcf2gbs_chr01.R
Convert vcf format to gbs format.
Take chromosome 1 as an example, the other chromosomes are the same
### sliding_vcf_stat.R
Calculate heterozygous
