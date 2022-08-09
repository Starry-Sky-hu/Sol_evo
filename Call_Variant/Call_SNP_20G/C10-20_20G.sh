seqtk sample -s300 C10-20_clean_R1.fq.gz 67000000 > C10-20_20G_1.fq
seqtk sample -s300 C10-20_clean_R2.fq.gz 67000000 > C10-20_20G_2.fq

pigz -p 52 C10-20_20G_1.fq
pigz -p 52 C10-20_20G_2.fq

source activate annotation_2
fastp --detect_adapter_for_pe -w 4 -i C10-20_20G_1.fq.gz -I C10-20_20G_2.fq.gz -o C10-20_20G_clean_1.fq.gz -O C10-20_20G_clean_2.fq.gz --json C10-20_fastp.json --html C10-20_fastp.html

ref=../Solanum_tuberosumDM.fa
#bwa index ${ref}
#samtools faidx ${ref}

bwa mem -t 52 -R "@RG\tID:C10-20_NGS\tSM:C10-20_NGS\tPL:il\tPU:NGS" ${ref} C10-20_20G_clean_1.fq.gz C10-20_20G_clean_2.fq.gz > DM_C10-20_NGS.sam
samtools sort -@ 52 DM_C10-20_NGS.sam -o DM_C10-20_NGS.sort.bam
samtools rmdup DM_C10-20_NGS.sort.bam DM_C10-20_NGS.rmdup.bam
samtools index DM_C10-20_NGS.rmdup.bam

for i in {01..12}
do
        echo "bcftools mpileup -Ou -r chr${i} --threads 4 -f ${ref} DM_C10-20_NGS.rmdup.bam | bcftools call -m -Ov --threads 4 -o DM_C10-20_NGS_chr${i}.g.vcf" >> call_C10-20.sh
done

parallel -j 12 < call_C10-20.sh
