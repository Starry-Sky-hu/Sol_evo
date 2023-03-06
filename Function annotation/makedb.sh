#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 
#SBATCH -J makedb.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_makedb.sh
#SBATCH --output=out_%J_makedb.sh
##################################################################
# @Author: huyong
# @Created Time : Thu Mar  3 19:45:16 2022

# @File Name: makedb.sh
# @Description:
##################################################################

formatdb -i /home/huyong/software/database/Araport11/Araport11_genes.201606.pep -o F -p T
formatdb -i /home/huyong/software/database/uniport/uniprot_sprot.fasta -o F -p T

