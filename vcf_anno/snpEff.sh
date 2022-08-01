ln -s /home/wuyaoyao/03-Solanaceae/SolEvo_Paper/09_GenomicPrediction/02_F2/00_E463_A626_Geno/E463_A6-26_chr*_filter.vcf .
ln -s /home/wuyaoyao/test/05_PartOne/01_Ref/Solanum_tuberosumE463.fa .

# build
mkdir ~/software/snpEff/data/Solanum_tuberosumE463
cp /home/wuyaoyao/test/05_PartOne/05_GFF/Solanum_tuberosumE463.Primary.gff3 ~/software/snpEff/data/Solanum_tuberosumE463/genes.gff
cp /home/wuyaoyao/test/05_PartOne/01_Ref/Solanum_tuberosumE463.fa ~/software/snpEff/data/Solanum_tuberosumE463/sequences.fa
~/software/snpEff/scripts/snpEff build -gff3 Solanum_tuberosumE463

# annotation
for i in {01..12}
do
        mkdir chr${i}
        cd chr${i}
        ~/software/snpEff/scripts/snpEff ann Solanum_tuberosumE463 ../E463_A6-26_chr${i}_filter.vcf > E463_A6-26_chr${i}_filter_anno.vcf
        cd ..
done
