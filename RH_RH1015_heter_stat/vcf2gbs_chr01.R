library(SNPRelate)
library(regress)
library(tidyr)
library(dplyr)

vcf.fn <- "RH_RH1015_chr01_ok.vcf"
snpgdsVCF2GDS(vcf.fn, "RH_RH1015_chr01_ok.gbs", method="copy.num.of.ref")
