seqtk sample -s300 RH-gDNA_L1_I307.R1.clean.fastq.gz 40200000 > RH_20G_1.fq
seqtk sample -s300 RH-gDNA_L1_I307.R2.clean.fastq.gz 40200000 > RH_20G_2.fq

pigz -p 52 RH_20G_1.fq
pigz -p 52 RH_20G_2.fq

source activate annotation_2
fastp --detect_adapter_for_pe -w 4 -i RH_20G_1.fq.gz -I RH_20G_2.fq.gz -o RH_20G_clean_1.fq.gz -O RH_20G_clean_2.fq.gz --json RH_fastp.json --html RH_fastp.html

ref=../Solanum_tuberosumDM.fa
#bwa index ${ref}
#samtools faidx ${ref}

bwa mem -t 52 -R "@RG\tID:RH_NGS\tSM:RH_NGS\tPL:il\tPU:NGS" ${ref} RH_20G_clean_1.fq.gz RH_20G_clean_2.fq.gz > DM_RH_NGS.sam
samtools sort -@ 52 DM_RH_NGS.sam -o DM_RH_NGS.sort.bam
samtools rmdup DM_RH_NGS.sort.bam DM_RH_NGS.rmdup.bam
samtools index DM_RH_NGS.rmdup.bam

for i in {01..12}
do
        echo "bcftools mpileup -Ou -r chr${i} --threads 4 -f ${ref} DM_RH_NGS.rmdup.bam | bcftools call -m -Ov --threads 4 -o DM_RH_NGS_chr${i}.g.vcf" >> call_RH.sh
done

parallel -j 12 < call_RH.sh

