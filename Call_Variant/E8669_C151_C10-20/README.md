# Data source
367 accessions vcf      /home/wuyaoyao/03-Solanaceae/SolEvo_Paper/08_Deleterious/02_RareAllele/01_VCF/DMV6_chr*_GATKFilterd.snp_367MR0.5.recode.vcf

C151    /home/huyong/tmp/yunnan/05_C151/01_parent/ACIP151_H7VGJALXX_L1_1.clean.fq.gz
                /home/huyong/tmp/yunnan/05_C151/01_parent/ACIP151_H7VGJALXX_L1_2.clean.fq.gz

A626    /vol3/agis/huangsanwen_group/tangdie/data/07_A157-22-3-42-40/wgs/A6-26_1.clean.fq.gz
                /vol3/agis/huangsanwen_group/tangdie/data/07_A157-22-3-42-40/wgs/A6-26_2.clean.fq.gz

E463    /public/agis/huangsanwen_group/zhangchunzhi/paper/02_inbreds_F1/01_dele_substitutions/reads/E454-2-77-18_BDSW192019661-1a/E4-63_1.clean.fq.gz
                /public/agis/huangsanwen_group/zhangchunzhi/paper/02_inbreds_F1/01_dele_substitutions/reads/E454-2-77-18_BDSW192019661-1a/E4-63_2.clean.fq.gz

RH      /vol3/agis/huangsanwen_group/wangpei/vol2_data/01_ng_backup/01_parent/RH_10G_1.fq.gz
        /vol3/agis/huangsanwen_group/wangpei/vol2_data/01_ng_backup/01_parent/RH_10G_2.fq.gz

C10-20  ncbi download SRR12791373

E8669   Baidu Netdisk download from XiuHan Jiang




# Code and results
## C151, A626, E463, RH, C10-20, E8669 Call SNP
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/A626/work.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/A626/DM_A626_NGS_chr*.g.vcf

/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/C10-20/work.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/C10-20/DM_C10-20_NGS_chr*.g.vcf

/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/C151/work.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/C151/DM_C151_NGS_chr*.g.vcf

/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/E463/work.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/E463/DM_E463_NGS_chr*.g.vcf

/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/E8669/work.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/E8669/DM_E8669_NGS_chr*.g.vcf

/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/RH/work.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/RH/DM_RH_NGS_chr*.g.vcf


## get SNP
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/gvcf_merge/get_snps/con.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/gvcf_merge/get_snps/DM_*_NGS_chr*.snps.sort.gvcf.gz


## C151, A626, E463, RH, C10-20, E8669 gvcf merge and filter
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/gvcf_merge/merge.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/gvcf_merge/chr*_merge_filter.vcf


## merge with 367 accessions vcf
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/gvcf_merge/merge_367_missing_noindel/merge.sh
/home/huyong/SolanaceaeGenomeAnalyze/Call_Variant/final_RH_E8669_C151_C10-20_NGS/gvcf_merge/merge_367_missing_noindel/chr*_merge_missing.vcf

