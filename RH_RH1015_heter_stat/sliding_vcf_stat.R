library(SNPRelate)
library(regress)
library(tidyr)
library(dplyr)

Args<-commandArgs(TRUE)
options(scipen = 200)
gbs_file = Args[1]
chrom = Args[2]
win = Args[3]
results = Args[4]

all.window=read.table(win, header=T)
window.chr=all.window[all.window$chrom==chrom,]

geno <- snpgdsOpen(gbs_file)
X_all <- snpgdsGetGeno(geno)
sample.id <- read.gdsn(index.gdsn(geno, "sample.id"))
snp_infor=snpgdsSNPList(geno, sample.id=NULL)
genotype=data.frame(t(X_all))
names(genotype)=sample.id

all.onewindat.infor={}
for( n in 1:nrow(window.chr) ){
  oneWindow=window.chr[n,]
  index=(snp_infor$position >=oneWindow$start & snp_infor$position<=oneWindow$end)
  geno_window=genotype[index,]

  win <- geno_window %>%
    group_by(RH1015,RH) %>%
    summarise(count=n())
  
  win_info <- data.frame(win)
  win_info <- na.omit(win_info)
  snp_num <- sum(win_info$count[!is.na(win_info$RH1015)])
  heter_num <- sum(win_info$count[win_info$RH1015 == 1])
  
  onewindat.infor=data.frame(oneWindow,heter_num,snp_num)
  all.onewindat.infor=rbind(all.onewindat.infor,onewindat.infor)
}

all.onewindat.infor$heter_ratio <- all.onewindat.infor$heter_num /all.onewindat.infor$snp_num
write.table(all.onewindat.infor, results, quote=F, sep='\t', row.names=F)

