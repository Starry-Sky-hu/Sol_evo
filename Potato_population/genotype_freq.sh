#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 10
#SBATCH -J genotype_freq.sh
#SBATCH -x comput59
#SBATCH --qos=queue1
#SBATCH --error=err_%J_genotype_freq.sh
#SBATCH --output=out_%J_genotype_freq.sh
##################################################################
# @Author: huyong
# @Created Time : Fri Dec  2 22:12:26 2022

# @File Name: genotype_freq.sh
# @Description:
##################################################################

ln -s /home/huyong/SolanaceaeGenomeAnalyze/landrace_freq/vcf_stat.* .

cat ../chr01.DP4_100.GQ10.Q30.MR0.5.maf0.001.recode.vcf > DP4_100.GQ10.Q30.MR0.5.maf0.001.recode.vcf
for i in {02..12}
do
    grep -v "#" ../chr${i}.DP4_100.GQ10.Q30.MR0.5.maf0.001.recode.vcf >> DP4_100.GQ10.Q30.MR0.5.maf0.001.recode.vcf
done
java vcf_stat DP4_100.GQ10.Q30.MR0.5.maf0.001.recode.vcf

awk '{print $1,$2,($8+$12)/($8+$9+$10+$11+$12)}' DP4_100.GQ10.Q30.MR0.5.maf0.001.recode.vcf.hstat > hstat


