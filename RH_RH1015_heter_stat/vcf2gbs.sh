#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 12
#SBATCH -J extract_RH_hete.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_extract_RH_hete.sh
#SBATCH --output=out_%J_extract_RH_hete.sh
##################################################################
# @Author: huyong
# @Created Time : Tue Mar 29 10:53:50 2022

# @File Name: extract_RH_hete.sh
# @Description:
##################################################################

for i in {01..12}
do
        echo "python extract_RH.py RH_RH1015_chr${i}_filter_add.vcf RH_RH1015_chr${i}_ok.vcf" >> get_ok.sh
done
parallel -j 12 < get_ok.sh


source /home/wuyaoyao/miniconda3/bin/activate r-4.1
for i in {01..12}
do
        echo "/home/wuyaoyao/miniconda3/envs/r-4.1/bin/Rscript vcf2gbs_chr${i}.R" >> para.sh
done
parallel -j 12 < para.sh

