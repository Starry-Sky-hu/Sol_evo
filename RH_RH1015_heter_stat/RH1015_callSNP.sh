
minimap2 -t 52 -ax map-hifi Solanum_tuberosumDM.fa RH1015.ccs.fa.gz > DM_v6_RH1015_aln.sam
samtools sort DM_v6_RH1015_aln.sam -O bam -@ 52 -m 2G > DM_v6_RH1015_aln.sort.bam
samtools index DM_v6_RH1015_aln.sort.bam

for i in {01..12}
do
        echo "bcftools mpileup -X pacbio-ccs -Ou -r chr${i} -f Solanum_tuberosumDM.fa DM_v6_RH1015_aln.sort.bam | bcftools call -m -Ov -V indels -o DM_v6_RH1015_chr${i}.gvcf" >> call.sh
done
parallel -j 12 < call.sh


for i in {01..12}
do
       echo "bcftools view -M2 -V indels -i'5 <= DP && DP <= 200 && MQ >= 40 && QUAL >=30 && FS < 60' DM_v6_RH1015_chr${i}.gvcf > DM_v6_RH1015_chr${i}_filter.gvcf" >> filter.sh
done
parallel -j 12 < filter.sh

