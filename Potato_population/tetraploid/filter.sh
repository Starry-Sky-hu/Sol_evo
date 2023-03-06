#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 
#SBATCH -J work.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh
##################################################################
# @Author: huyong
# @Created Time : Sun Aug 28 12:27:50 2022

# @File Name: work.sh
# @Description:
##################################################################

for i in {01..01}
do
    ln -s ../Landrace_add_ploidy4_p2/Landrace_add_ploidy4_p2_chr${i}_merge.vcf.gz* .
    echo """#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --qos=queue1

/public/software/env01/bin/gatk SelectVariants -select-type SNP -V Landrace_add_ploidy4_p2_chr${i}_merge.vcf.gz -O Landrace_add_ploidy4_p2_chr${i}_merge.snp.vcf.gz
/public/software/env01/bin/gatk VariantFiltration -V Landrace_add_ploidy4_p2_chr${i}_merge.snp.vcf.gz --filter-expression \"QD < 2.0\" --filter-name \"LowQD\" --filter-expression \"MQ < 40.0\" --filter-name \"MQ40.0\" --filter-expression \"FS > 60.0\" --filter-name \"FS60.0\" --filter-expression \"SOR > 3.0\" --filter-name \"SOR3.0\" --filter-expression \"MQRankSum < -12.5\" --filter-name \"MQRankSum-12.5\" --filter-expression \"ReadPosRankSum < -8.0\" --filter-name \"ReadPosRankSum-8.0\" -O Landrace_add_ploidy4_p2_chr${i}_merge.snp.filter.vcf

awk '/^#/||\$7==\"PASS\"' Landrace_add_ploidy4_p2_chr${i}_merge.snp.filter.vcf > Landrace_add_ploidy4_p2_chr${i}_merge.snp.hardfilter.vcf
bcftools view -m2 -M2 Landrace_add_ploidy4_p2_chr${i}_merge.snp.hardfilter.vcf > Landrace_add_ploidy4_p2_chr${i}_merge.snp.hardfilter.M2.vcf
vcftools --vcf Landrace_add_ploidy4_p2_chr${i}_merge.snp.hardfilter.M2.vcf --minDP 4 --max-missing 0.5 --maf 0.001 --recode --recode-INFO-all --out Landrace_add_ploidy4_p2_chr${i}_DP4.MR0.5.maf0.001
""" > filter_chr${i}.sh
sbatch filter_chr${i}.sh
done

