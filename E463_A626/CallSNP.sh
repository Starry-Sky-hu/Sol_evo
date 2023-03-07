#!/bin/bash
#SBATCH --partition=smp01
#SBATCH -N 1
#SBATCH -c 52
#SBATCH -J work_1.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_work_1.sh
#SBATCH --output=out_%J_work_1.sh
##################################################################
# @Author: huyong
# @Created Time : Thu Apr 21 13:15:57 2022

# @File Name: work_1.sh
# @Description:
##################################################################

ref=Solanum_tuberosumE463.fa
bwa index ${ref}
samtools faidx ${ref}

bwa mem -t 52 -R "@RG\tID:A6-26_NGS\tSM:A6-26_NGS\tPL:il\tPU:NGS" ${ref} A6-26_1.clean.fq.gz A6-26_2.clean.fq.gz > E463_A6-26.sam
samtools sort -@ 52 E463_A6-26.sam -o E463_A6-26.sort.bam
samtools rmdup E463_A6-26.sort.bam E463_A6-26.rmdup.bam
samtools index E463_A6-26.rmdup.bam

for i in {01..12}
do
        echo "bcftools mpileup -Ou -r E4-63_chr${i} --threads 4 -f ${ref} E463_A6-26.rmdup.bam | bcftools call -m -Ov --threads 4 -o E463_A6-26_chr${i}.g.vcf" >> call_A6-26.sh
done

parallel -j 12 < call_A6-26.sh

for i in {01..12}
do
       echo "bcftools view -M2 -v snps -i'3 <= DP && DP <= 100 && MQ >= 40 && QUAL >=30 && FS < 60' E463_A6-26_chr${i}.g.vcf > E463_A6-26_chr${i}_filter.vcf" >> filter.sh
done

for i in {01..12}
do
       echo "bcftools view -M2 -V indels -i'3 <= DP && DP <= 100 && MQ >= 40 && QUAL >=30 && FS < 60' E463_A6-26_chr${i}.g.vcf > E463_A6-26_chr${i}_filter.g.vcf" >> filter.sh
done

parallel -j 24 < filter.sh
