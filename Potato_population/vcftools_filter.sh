for i in {01..12}
do
   echo "#!/bin/bash
#SBATCH --partition=low,big,queue1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH --qos=queue1
/public/software/env01/bin/vcftools --vcf chr${i}.combined.snp.hardfilter.M2.vcf --minDP 4 --maxDP 100 --minGQ 10 --minQ 30 --max-missing 0.5 --recode --maf 0.001 --recode-INFO-all --out chr${i}.DP4_100.GQ10.Q30.MR0.5.maf0.001
" > chr${i}_filter.sh
done
