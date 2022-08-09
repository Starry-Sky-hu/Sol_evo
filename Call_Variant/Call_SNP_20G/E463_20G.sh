seqtk sample -s300 E4-63_1.clean.fq.gz 67000000 > E463_20G_1.fq
seqtk sample -s300 E4-63_2.clean.fq.gz 67000000 > E463_20G_2.fq

pigz -p 50 E463_20G_1.fq
pigz -p 50 E463_20G_2.fq

source activate annotation_2
fastp --detect_adapter_for_pe -w 4 -i E463_20G_1.fq.gz -I E463_20G_2.fq.gz -o E463_20G_clean_1.fq.gz -O E463_20G_clean_2.fq.gz --json E463_fastp.json --html E463_fastp.html

ref=../Solanum_tuberosumDM.fa
#bwa index ${ref}
#samtools faidx ${ref}

bwa mem -t 50 -R "@RG\tID:E463_NGS\tSM:E463_NGS\tPL:il\tPU:NGS" ${ref} E463_20G_clean_1.fq.gz E463_20G_clean_2.fq.gz > DM_E463_NGS.sam
samtools sort -@ 50 DM_E463_NGS.sam -o DM_E463_NGS.sort.bam
samtools rmdup DM_E463_NGS.sort.bam DM_E463_NGS.rmdup.bam
samtools index DM_E463_NGS.rmdup.bam

for i in {01..12}
do
        echo "bcftools mpileup -Ou -r chr${i} --threads 4 -f ${ref} DM_E463_NGS.rmdup.bam | bcftools call -m -Ov --threads 4 -o DM_E463_NGS_chr${i}.g.vcf" >> call_E463.sh
done

parallel -j 12 < call_E463.sh

