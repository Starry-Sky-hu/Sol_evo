#!/bin/bash
#SBATCH --partition=low,big,gpu,smp01,queue1
#SBATCH -N 1
#SBATCH -c 4
#SBATCH -J test.sh
#SBATCH --qos=queue1
#SBATCH --error=err_%J_test.sh
#SBATCH --output=out_%J_test.sh
# @Created Time : Thu Mar  3 19:13:03 2022

threads=4
mkdir ara interproscan swissprot
sed 's/\*//g' /home/huyong/SolanaceaeGenomeAnalyze/reference/06_Protein_Primary/test.pep.fa > test.pep_noa.fa
singularity exec ~/contianer/GenomeAssemblyContainer_v0.2 seqkit split -s 1000 test.pep_noa.fa -O pep_split

####
#### Test 
####
#head -n60 /home/huyong/SolanaceaeGenomeAnalyze/reference/06_Protein_Primary/Solanum_ochranthum.pep.fa | sed 's/\*//g' > Solanum_ochranthum.pep_noa.fa
#singularity exec ~/contianer/GenomeAssemblyContainer_v0.2 seqkit split -s 1 Solanum_ochranthum.pep_noa.fa -O pep_split


#### interproscan
source activate domain
cd interproscan
ls ../pep_split/*fa > pep_split_list
for i in $(cat pep_split_list)
do
    interproscan.sh -i ${i} \
                    -o ${i##*/}.interscan.tsv \
                    -goterms -iprlookup -pa -f TSV -dp -cpu ${threads}
done
cd ..

#### ara
cd ara
ls ../pep_split/*fa > pep_split_list
for i in $(cat pep_split_list)
do
    blastall -p blastp \
            -d /home/huyong/software/database/Araport11/Araport11_genes.201606.pep \
            -i ${i} \
            -o ${i##*/}.ara.blast.out \
            -F F -m 9 -b 3 -e 1e-5 -a ${threads}
done
cd ..

#### swissprot
cd swissprot
ls ../pep_split/*fa > pep_split_list
for i in $(cat pep_split_list)
do
    blastall -p blastp \
        -d /home/huyong/software/database/uniport/uniprot_sprot.fasta \
        -i ${i} \
        -o ${i##*/}.uniport.blast.out \
        -F F -m 9 -b 3 -e 1e-5 -a ${threads}
done
cd ..

####
####  merge
####
gff=/home/huyong/SolanaceaeGenomeAnalyze/reference/05_GFF/test.Primary.gff3

## ara
cat ara/*.ara.blast.out > test.ara.blast.out
/home/huyong/software/fun_anno_script/extract_function.py -i1 /home/huyong/software/database/Araport11/Araport11_genes.201606.pep \
    -i2 test.ara.blast.out \
    -o test.Aradatabase.out

## swissprot
cat swissprot/*.uniport.blast.out > test.uniport.blast.out
/home/huyong/software/fun_anno_script/extract_function.py -i1 /home/huyong/software/database/uniport/uniprot_sprot.fasta \
        -i2 test.uniport.blast.out \
        -o test.to_Swissprot.out

## interproscan
cat interproscan/*.interscan.tsv > test.interscan.tsv

awk 'BEGIN{FS = "\t"}{for (f=1; f <= NF; f+=1) {if ($f ~ /IPR/) {print $1"\t"$f"\t"$(f+1)}}}' test.interscan.tsv > test.interpro_annot_all
awk 'BEGIN{FS = "\t"}{for (f=1; f <= NF; f+=1) {if ($f ~ /GO:/) {print $1"\t"$f}}}' test.interscan.tsv > test.go_annot_all
sed -i 's/|GO/\tGO/g' test.go_annot_all
awk -F '\t' 'BEGIN{OFS="~"}{print $1,$2,$3}' test.interpro_annot_all | sort | uniq > test.interpro_annot_uniq_all

/home/huyong/software/fun_anno_script/combine_interpro_result.py test.interpro_annot_uniq_all > test.interpro.xls
/home/huyong/software/fun_anno_script/combine_GO_result.py test.go_annot_all test.GO_combine.xls
grep -v "^$" test.GO_combine.xls > test.GO_combine.xls.tmp
mv test.GO_combine.xls.tmp test.GO_combine.xls
python /home/huyong/software/fun_anno_script/add_GO_infor.py /home/huyong/software/database/goterm.obo test.GO_combine.xls test.GO_combine_info.xls
/home/huyong/software/fun_anno_script/combine_gff3_GO_IPR.py test.GO_combine_info.xls test.interpro.xls ${gff} | sort -k1,1 -k2,2n > test.pos.go.ipr.txt
/home/huyong/software/fun_anno_script/combine_gff3_Swiss_Ara.py test.to_Swissprot.out test.Aradatabase.out ${gff} | sort -k1,1 -k2,2n > test.Swiss_Ara.txt

paste test.pos.go.ipr.txt <(awk -F '\t' 'BEGIN{OFS="\t"}{print $5,$6}' test.Swiss_Ara.txt) > test.GO_IPR_Swiss_Ara.txt



