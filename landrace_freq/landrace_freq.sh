ln -s /home/wuyaoyao/03-Solanaceae/SolEvo_Paper/08_Deleterious/02_RareAllele/01_VCF/DMV6_chr*_GATKFilterd.snp_367MR0.5_landrace.recode.vcf .
javac vcf_stat.java 

for i in {01..12}
do
        echo """#!/bin/bash
#SBATCH --partition=low,big,queue1
#SBATCH -N 1
#SBATCH -c 5
#SBATCH --qos=queue1

java vcf_stat DMV6_chr${i}_GATKFilterd.snp_367MR0.5_landrace.recode.vcf

echo \"Chr     Pos     Ref     Alt       0/1     0/0     1/1\" > chr${i}_genoetype_stat
grep -v \"Chr\" DMV6_chr${i}_GATKFilterd.snp_367MR0.5_landrace.recode.vcf.hstat | awk '{print \$1,\$2,\$3,\$4,\$8/(\$8+\$9+\$11),\$9/(\$8+\$9+\$11),\$11/(\$8+\$9+\$11)}' OFS='\t' >> chr${i}_genoetype_stat""" > chr${i}.sh
sbatch chr${i}.sh
done
