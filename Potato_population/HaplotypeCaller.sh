for i in $(cat Landrace_187_Add6Accession.txt)
do
   mkdir ${i}
   fq=($(ls ../clean_data/${i}/*gz))
   echo """#!/bin/bash
#SBATCH --partition=queue1,low,big
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --qos=queue1
#SBATCH -x io1,io2,io3,io4,io5,io6,io8,io9,io10,io11,io12

bwa mem -t 4 -R \"@RG\tID:${i}\tSM:${i}\tPL:illumina\" ../../Solanum_tuberosumDM.fa ../${fq[0]} ../${fq[1]} > ${i}_bwa.sam
samtools sort -@ 4 ${i}_bwa.sam -o ${i}_bwa_sort.bam
samtools rmdup ${i}_bwa_sort.bam ${i}_bwa_sort_rmdup.bam
samtools index -@ 4 ${i}_bwa_sort_rmdup.bam

gatk HaplotypeCaller -R ../../Solanum_tuberosumDM.fa -I ${i}_bwa_sort_rmdup.bam -O ${i}.g.vcf.gz -ERC GVCF""" > ${i}/${i}.sh

cd ${i}
sbatch ${i}.sh
cd ..
done
