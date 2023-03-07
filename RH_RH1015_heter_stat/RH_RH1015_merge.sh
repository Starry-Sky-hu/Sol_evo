#!/bin/bash
#SBATCH --partition=queue1,low,big
#SBATCH -N 1
#SBATCH -c 24
#SBATCH -J merge.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_merge.sh
#SBATCH --output=out_%J_merge.sh
##################################################################
# @Author: huyong
# @Created Time : Wed Apr  6 11:31:53 2022

# @File Name: merge.sh
# @Description:
##################################################################

ls *gvcf | sed 's/.gvcf//g' > list
for i in $(cat list)
do
    echo "bcftools sort -T /home/huyong/tmp/bcftools.${i} ${i}.gvcf -o ${i}.sort.gvcf" >> sort.sh
    echo "bgzip -@ 1 ${i}.sort.gvcf" >> gz.sh
    echo "tabix ${i}.sort.gvcf.gz" >> idx.sh
done

parallel -j 24 < sort.sh
parallel -j 24 < gz.sh
parallel -j 24 < idx.sh

for i in {01..12}
do
    VCFS=`ls *chr${i}*.gz | xargs -n100`
    echo "bcftools merge $VCFS > chr${i}_merge.vcf" >> b_merge.sh
done

parallel -j 12 < b_merge.sh

for i in {01..12}
do
    echo "bcftools view -M2 -i'MQ >= 40 && QUAL >=30 && FS < 60' chr${i}_merge.vcf > RH_RH1015_chr${i}_filter.vcf" >> filter.sh
done

parallel -j 12 < filter.sh

python homo_stat.py RH_RH1015_chr01_filter.vcf RH_RH1015_chr01_filter_error.vcf
