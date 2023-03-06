head -n1 ../Solanum_tuberosumDM.fa.fai | tail -n1 | while read chr len orther
do
   mkdir  ${chr}
   cd ${chr}
   sed 's/chr09/'${chr}'/g' ../chr09/chr09_Landrace_187_Add6Acc_ploidy4_p2_gvcf_path > ${chr}_Landrace_187_Add6Acc_ploidy4_p2_gvcf_path

   for i in `seq 1 5000000 ${len}`
   do
       let j=${i}+4999999

       if (( ${j} > ${len} ))
       then
           j=${len}
       fi

       echo """#!/bin/bash
#SBATCH --partition=queue1,low,big
#SBATCH -N 1
#SBATCH -c 2
#SBATCH --qos=queue1
#/home/huyong/software/gatk-4.1.9.0/gatk GenomicsDBImport -R ../../Solanum_tuberosumDM.fa -L ${chr}:${i}-${j} --sample-name-map ${chr}_Landrace_187_Add6Acc_ploidy4_p2_gvcf_path --genomicsdb-workspace-path ${chr}_${i}.db
/home/huyong/software/gatk-4.1.9.0/gatk GenotypeGVCFs -R ../../Solanum_tuberosumDM.fa --sample-ploidy 2 --max-genotype-count 8192 -O ${chr}_${i}.combined.vcf -V gendb://${chr}_${i}.db -L ${chr}:${i}-${j}""" > ${chr}_${i}.sh

       sbatch ${chr}_${i}.sh
   done

   cd ..
done
