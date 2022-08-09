seqtk sample -s300 ACIP151_H7VGJALXX_L1_1.clean.fq.gz 67000000 > C151_20G_1.fq
seqtk sample -s300 ACIP151_H7VGJALXX_L1_2.clean.fq.gz 67000000 > C151_20G_2.fq

pigz -p 52 C151_20G_1.fq
pigz -p 52 C151_20G_2.fq

source activate annotation_2
fastp --detect_adapter_for_pe -w 4 -i C151_20G_1.fq.gz -I C151_20G_2.fq.gz -o C151_20G_clean_1.fq.gz -O C151_20G_clean_2.fq.gz --json C151_fastp.json --html C151_fastp.html

ref=../Solanum_tuberosumDM.fa
#bwa index ${ref}
#samtools faidx ${ref}

bwa mem -t 52 -R "@RG\tID:C151_NGS\tSM:C151_NGS\tPL:il\tPU:NGS" ${ref} C151_20G_clean_1.fq.gz C151_20G_clean_2.fq.gz > DM_C151_NGS.sam
samtools sort -@ 52 DM_C151_NGS.sam -o DM_C151_NGS.sort.bam
samtools rmdup DM_C151_NGS.sort.bam DM_C151_NGS.rmdup.bam
samtools index DM_C151_NGS.rmdup.bam

for i in {01..12}
do
        echo "bcftools mpileup -Ou -r chr${i} --threads 4 -f ${ref} DM_C151_NGS.rmdup.bam | bcftools call -m -Ov --threads 4 -o DM_C151_NGS_chr${i}.g.vcf" >> call_C151.sh
done

parallel -j 12 < call_C151.sh

