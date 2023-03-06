#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -J work.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_work.sh
#SBATCH --output=out_%J_work.sh
##################################################################
# @Author: huyong
# @Created Time : Sun Aug 28 11:26:41 2022

# @File Name: work.sh
# @Description:
##################################################################

grep -f Landrace_187_Add6Accession.txt gvcf_path > Landrace_187_Add6Accession_gvcf_path
for i in {01..12}
do
    echo """#!/bin/bash
#SBATCH --partition=queue1,low,big
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --qos=queue1
/home/huyong/software/gatk-4.1.9.0/gatk GenomicsDBImport -R ../Solanum_tuberosumDM.fa -L chr${i} --sample-name-map Landrace_187_Add6Accession_gvcf_path --genomicsdb-workspace-path chr${i}.db --reader-threads 4
/home/huyong/software/gatk-4.1.9.0/gatk GenotypeGVCFs -R ../Solanum_tuberosumDM.fa --sample-ploidy 2 -O chr${i}.combined.vcf -V gendb://chr${i}.db -L chr${i}""" >> chr${i}.sh
sbatch chr${i}.sh
done

