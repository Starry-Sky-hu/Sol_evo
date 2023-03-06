#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --qos=queue1
#SBATCH --error=err_%J_con.sh
#SBATCH --output=out_%J_con.sh
##################################################################
# @Author: huyong
# @Created Time : Sun Aug 28 00:09:14 2022

# @File Name: con.sh
# @Description:
##################################################################

for i in $(cat ploidy4_list)
do
    mkdir ${i}
    fq=($(ls ../clean_data/${i}/*gz))
    echo """#!/bin/bash
#SBATCH --partition=queue1,low,big,smp01,gpu-3090,gpu-v100s
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --qos=queue1

#/public/software/env01/bin/bwa mem -t 4 -R \"@RG\tID:${i}\tSM:${i}\tPL:illumina\" ../../Solanum_tuberosumDM.fa ../${fq[0]} ../${fq[1]} > ${i}_bwa.sam
#/public/software/env01/bin/samtools sort -@ 4 ${i}_bwa.sam -o ${i}_bwa_sort.bam
#/public/software/env01/bin/samtools rmdup ${i}_bwa_sort.bam ${i}_bwa_sort_rmdup.bam
#/public/software/env01/bin/samtools index -@ 4 ${i}_bwa_sort_rmdup.bam

for j in {01..12}
do
    echo \"#!/bin/bash
#SBATCH --partition=queue1,low,big,smp01,gpu-3090,gpu-v100s
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --qos=queue1
#SBATCH -x io1,io2,io3,io4,io5,io6,io8,io9,io10,io11,io12,comput51

gatk HaplotypeCaller -R ../../Solanum_tuberosumDM.fa -L chr\${j} -I ${i}_bwa_sort_rmdup.bam -O ${i}_chr\${j}.g.vcf.gz -ERC GVCF\" > chr\${j}.sh
sbatch chr\${j}.sh
done
""" > ${i}/${i}.sh

cd ${i}
#sh ${i}.sh
cd ..
done
