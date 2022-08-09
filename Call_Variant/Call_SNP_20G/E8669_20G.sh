seqtk sample -s300 E86-69_1_R1.fq.gz 67000000 > E8669_20G_1.fq
seqtk sample -s300 E86-69_1_R2.fq.gz 67000000 > E8669_20G_2.fq

pigz -p 52 E8669_20G_1.fq
pigz -p 52 E8669_20G_2.fq

source activate annotation_2
fastp --detect_adapter_for_pe -w 4 -i E8669_20G_1.fq.gz -I E8669_20G_2.fq.gz -o E8669_20G_clean_1.fq.gz -O E8669_20G_clean_2.fq.gz --json E8669_fastp.json --html E8669_fastp.html

ref=../Solanum_tuberosumDM.fa
#bwa index ${ref}
#samtools faidx ${ref}

bwa mem -t 52 -R "@RG\tID:E8669_NGS\tSM:E8669_NGS\tPL:il\tPU:NGS" ${ref} E8669_20G_clean_1.fq.gz E8669_20G_clean_2.fq.gz > DM_E8669_NGS.sam
samtools sort -@ 52 DM_E8669_NGS.sam -o DM_E8669_NGS.sort.bam
samtools rmdup DM_E8669_NGS.sort.bam DM_E8669_NGS.rmdup.bam
samtools index DM_E8669_NGS.rmdup.bam

for i in {01..12}
do
        echo "bcftools mpileup -Ou -r chr${i} --threads 4 -f ${ref} DM_E8669_NGS.rmdup.bam | bcftools call -m -Ov --threads 4 -o DM_E8669_NGS_chr${i}.g.vcf" >> call_E8669.sh
done

parallel -j 12 < call_E8669.sh

