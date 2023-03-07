#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 14
#SBATCH -J stat.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_stat.sh
#SBATCH --output=out_%J_stat.sh
##################################################################
# @Author: huyong
# @Created Time : Sun Apr 17 14:06:12 2022

# @File Name: stat.sh
# @Description:
##################################################################

for i in {01..12}
do
        echo "/home/wuyaoyao/miniconda3/envs/r-4.1/bin/Rscript sliding_vcf_stat.R RH_RH1015_chr${i}_ok.gbs chr${i} 50k_window.txt RH_RH1015_chr${i}_ok_stat" >> stat 
done

parallel -j 12 < stat

cat RH_RH1015_chr01_ok_stat > RH_RH1015_heter_stat
for i in {02..12}
do
        grep -v "chrom" RH_RH1015_chr${i}_ok_stat >> RH_RH1015_heter_stat
done
