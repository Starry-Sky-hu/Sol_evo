
seqtk sample -s300 A6-26_1.clean.fq.gz 30000000 > A626_10G_1.fq
seqtk sample -s300 A6-26_2.clean.fq.gz 30000000 > A626_10G_2.fq

pigz -p 52 A626_10G_1.fq
pigz -p 52 A626_10G_2.fq

source activate annotation_2
fastp --detect_adapter_for_pe -w 4 -i A626_10G_1.fq.gz -I A626_10G_2.fq.gz -o A626_10G_clean_1.fq.gz -O A626_10G_clean_2.fq.gz --json A626_fastp.json --html A626_fastp.html

ref=../Solanum_tuberosumDM.fa
#bwa index ${ref}
#samtools faidx ${ref}

bwa mem -t 52 -R "@RG\tID:A626_NGS\tSM:A626_NGS\tPL:il\tPU:NGS" ${ref} A626_10G_clean_1.fq.gz A626_10G_clean_2.fq.gz > DM_A626_NGS.sam
samtools sort -@ 52 DM_A626_NGS.sam -o DM_A626_NGS.sort.bam
samtools rmdup DM_A626_NGS.sort.bam DM_A626_NGS.rmdup.bam
samtools index DM_A626_NGS.rmdup.bam

for i in {01..12}
do
        echo "bcftools mpileup -Ou -r chr${i} --threads 4 -f ${ref} DM_A626_NGS.rmdup.bam | bcftools call -m -Ov --threads 4 -o DM_A626_NGS_chr${i}.g.vcf" >> call_A626.sh
done

parallel -j 12 < call_A626.sh
