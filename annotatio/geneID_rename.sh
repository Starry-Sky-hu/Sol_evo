#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 
#SBATCH -J con.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_con.sh
#SBATCH --output=out_%J_con.sh
##################################################################
# @Author: huyong
# @Created Time : Sat Jan  8 19:43:03 2022

# @File Name: con.sh
# @Description:
##################################################################

for i in $(cat list)
do
        mkdir -p ${i}
        cd ${i}
        echo "cp /home/huyong/Yao_test/${i}/05_maker/${i}.all.maker.gff3 ." > rename.sh
        echo "perl ~/software/maker_AED_rename_S.pl -n ${i}_ -gff ${i}.all.maker.gff3" >> rename.sh
        echo "mv AED_1.maker.gff ${i}.all.rename.gff3" >> rename.sh
        echo "perl ~/software/maker/bin/quality_filter.pl -a 0.75 ${i}.all.rename.gff3 > ${i}.all.rename_0.75.gff3" >> rename.sh
        echo "perl /home/wuyaoyao/03-Solanaceae/src/longestCDS_PrimaryGff.pl ${i}.all.rename_0.75.gff3 > ${i}.all.rename_0.75_best.gff3" >> rename.sh
        echo "/home/wuyaoyao/software/iTools_Code/bin/iTools Gfftools getCdsPep -Ref ~/Yao_test/00_Ref/${i}.fa -Gff ${i}.all.rename_0.75_best.gff3 -OutPut ${i}" >> rename.sh
        echo "gunzip *gz" >> rename.sh
        cd ..
done


for i in $(cat list)
do
        cd ${i}
        sh rename.sh
        sleep 5
        cd ..
done
