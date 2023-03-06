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

for i in {01..12}
do
    echo """#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --qos=queue1

gatk SelectVariants -select-type SNP -V chr${i}.combined.vcf -O chr${i}.combined.snp.vcf.gz
gatk VariantFiltration -V chr${i}.combined.snp.vcf.gz --filter-expression \"QD < 2.0\" --filter-name \"LowQD\" --filter-expression \"MQ < 40.0\" --filter-name \"MQ40.0\" --filter-expression \"FS > 60.0\" --filter-name \"FS60.0\" --filter-expression \"SOR > 3.0\" --filter-name \"SOR3.0\" --filter-expression \"MQRankSum < -12.5\" --filter-name \"MQRankSum-12.5\" --filter-expression \"ReadPosRankSum < -8.0\" --filter-name \"ReadPosRankSum-8.0\" -O chr${i}.combined.snp.filter.vcf

awk '/^#/||\$7==\"PASS\"' chr${i}.combined.snp.filter.vcf > chr${i}.combined.snp.hardfilter.vcf
bcftools view -M2 chr${i}.combined.snp.hardfilter.vcf > chr${i}.combined.snp.hardfilter.M2.vcf

gatk SelectVariants -select-type INDEL -V chr${i}.combined.vcf -O chr${i}.combined.indel.vcf.gz
gatk VariantFiltration -V chr${i}.combined.indel.vcf.gz --filter-expression \"QD < 2.0\" --filter-name \"LowQD\" --filter-expression \"MQ < 40.0\" --filter-name \"MQ40.0\" --filter-expression \"FS > 200.0\" --filter-name \"FS200\" --filter-expression \"SOR > 10.0\" --filter-name \"SOR10\" --filter-expression \"MQRankSum < -12.5\" --filter-name \"MQRankSum-12.5\" --filter-expression \"ReadPosRankSum < -8.0\" --filter-name \"ReadPosRankSum-8.0\" -O chr${i}.combined.indel.filter.vcf
""" > filter_chr${i}.sh
sbatch filter_chr${i}.sh
sleep 3
done

