for i in A626 C10-20 C151 E463 E8669 RH
do
   for j in {01..12}
   do
       echo "bcftools view -M2 -V indels -i'sum(DP4) <= 100 && sum(DP4) >=4 && MQ >= 40 && QUAL >=30 && FS < 60 && (((DP4[0]+DP4[1])/sum(DP4) >= 0.3 && (DP4[0]+DP4[1])/sum(DP4) <= 0.7) || (DP4[0]+DP4[1])/sum(DP4) == 0 || (DP4[2]+DP4[3])/sum(DP4) == 0)' DM_${i}_NGS_chr${j}.g.vcf > DM_${i}_NGS_chr${j}_filter_DP4.g.vcf" >> filter.sh
   done
done
parallel -j 48 < filter.sh


ls *_filter_DP4.g.vcf | sed 's/_filter_DP4.g.vcf//g' > vcf_list
for i in $(cat vcf_list)
do
    echo "#!/bin/bash
#SBATCH --partition=queue1,low,big
#SBATCH -N 1
#SBATCH -c 1
grep -v 'INDEL;' ${i}_filter_DP4.g.vcf > ${i}_filter_DP4.snps.g.vcf
bcftools sort -T /home/huyong/tmp/bcftools.${i} ${i}_filter_DP4.snps.g.vcf -o ${i}_filter_DP4.snps.sort.gvcf

bgzip -@ 1 ${i}_filter_DP4.snps.sort.gvcf
tabix ${i}_filter_DP4.snps.sort.gvcf.gz
    " > ${i}_get_snps.sh
sbatch ${i}_get_snps.sh
done

for i in {01..12}
do
    VCFS=`ls *chr${i}*.gz | xargs -n100`
    echo "bcftools merge $VCFS > chr${i}_20G_merge_DP4_0.3_0.7.g.vcf" >> chr_merge.sh
done
parallel -j 12 < chr_merge.sh



