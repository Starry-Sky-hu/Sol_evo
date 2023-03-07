#!/bin/bash
#SBATCH --partition=queue1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -J stat_.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_stat_.sh
#SBATCH --output=out_%J_stat_.sh
##################################################################
# @Author: huyong
# @Created Time : Sat May 14 16:16:15 2022

# @File Name: stat_.sh
# @Description:
##################################################################

for i in $(cat list)
do
   mkdir ${i}
   cd ${i}
   ln -s /home/huyong/Yao_test/${i}/01_fastp/*gz .
   cd ..
done

for i in $(cat list)
do
   cd ${i}
   ls *gz | sed 's/_clean_1.fq.gz//g' | sed 's/_clean_2.fq.gz//g' | sort | uniq > ${i}_list
   for j in $(cat ${i}_list)
   do
       mkdir ${j}
       cd ${j}
       mv ../${j}*gz .
       cd ..
   done
   cd ..
done

for i in $(cat list)
do
   cd ${i}
   for j in $(cat ${i}_list)
   do
       cd ${j}
       echo """#!/bin/bash
#SBATCH --partition=smp01,big
#SBATCH -N 1
#SBATCH -c 1
seq_n50.pl <(fq2fa.pl <(zcat *.gz)) > ${j}_stat
       """ > ${j}.sh
       sbatch ${j}.sh
       cd ..
   done
   cd ..
done

for i in $(cat Solanum_nigrum_list)
do
    echo -n "${i##*/}   " >> Solanum_nigrum_stat
    base=`grep "Total" ${i} | awk '{print $2}'`
    reads=`grep "Count" ${i} | awk '{print $2}'`
    mean=`grep "Average" ${i} | awk '{print $2}'`
    echo "${base}   ${reads}    ${mean}">> Solanum_nigrum_stat
done
