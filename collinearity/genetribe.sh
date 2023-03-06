#!/bin/bash
#SBATCH --partition=arm
#SBATCH -N 1
#SBATCH -c 96
#SBATCH -J protein.sh
#SBATCH -x armcomput2,armcomput4,armcomput8,armcomput7,armcomput9,armcomput17,armcomput33,armcomput35,armcomput36
#SBATCH --qos=queue1
#SBATCH --error=err_%J_genetribe.sh
#SBATCH --output=out_%J_genetribe.sh
##################################################################
# @Author: huyong
# @Created Time : Sat Jan  8 14:45:58 2022

# @File Name: genetribe.sh
# @Description:
##################################################################

source /home/huyong/software_arm/mambaforge/bin/activate singularity

ln -s /home/huyong/SolanaceaeGenomeAnalyze/reference/05_GFF/protein.Primary.gff3 .
ln -s /home/huyong/SolanaceaeGenomeAnalyze/reference/06_Protein_Primary/protein.pep.fa protein.fa

singularity exec /home/huyong/contianer_arm/collinearity_v1.6.sif python -m jcvi.formats.gff bed --type=mRNA --key=ID protein.Primary.gff3 -o protein.bed

cp ../chrlist protein.chrlist

ln -s ../ref/Solanum_tuberosumDM.bed .
ln -s ../ref/Solanum_tuberosumDM.fa .
ln -s ../ref/Solanum_tuberosumDM.chrlist .

date
singularity exec /home/huyong/contianer_arm/collinearity_v1.6.sif \
        /home/genetribe-master/genetribe core -l protein -f Solanum_tuberosumDM -n 96 -s ~
date
