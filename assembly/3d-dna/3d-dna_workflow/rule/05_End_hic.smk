



#################################      Index      ###########################
rule index_bowtie:
	input:
		ref = "refenrence/"+ref
	output:
		bowtie_index = "results/02_assembly/03_hic/06_End_hic/{sample}_hifiasm.hic.p_ctg_clean.fasta.rev.1.bt2"
	threads:
		60
	params:
		ref_prefix = "{sample}"
	shell:
		"""
		singularity exec GenomeAssemblyContainer_v0.2 \
		bowtie2-build --threads {threads} -f {input.ref} {wildcards.sample}_hifiasm.hic.p_ctg_clean.fasta

		mv {params.ref_prefix}*bt2 results/02_assembly/03_hic/06_End_hic/
		"""


rule digest:
	input:
		ref = "refenrence/"+ref
	output:
		digest_txt = "results/02_assembly/03_hic/06_End_hic/{sample}_hifiasm.hic.p_ctg_clean.fasta_MboI.txt"
	shell:
		"""
		singularity exec GenomeAssemblyContainer_v0.2 \
		digest_genome.py -r ^GATC -o {output.digest_txt} {input.ref}
		"""

rule samtools_faidx:
	input:
		ref = "refenrence/"+ref
	output:
		fai_index = "refenrence/{sample}_hifiasm.hic.p_ctg_clean.fasta.fai"
	shell:
		"""
		singularity exec GenomeAssemblyContainer_v0.2 \
		samtools faidx {input.ref}
		"""


rule fai2size:
	input:
		fai_index = rules.samtools_faidx.output.fai_index
	output:
		size_txt = "results/02_assembly/03_hic/06_End_hic/{sample}_hifiasm.hic.p_ctg_clean.fasta.size"
	shell:
		"""
		singularity exec GenomeAssemblyContainer_v0.2 \
		awk '{{print $1"\t"$2}}' {input.fai_index} > {output.size_txt}
		"""




################################    HicPro    #############################
rule hic_pro:
	input:
		fai_index = rules.samtools_faidx.output.fai_index,
		digest_txt = rules.digest.output.digest_txt,
		bowtie_index = rules.index_bowtie.output.bowtie_index,
		size_txt = rules.fai2size.output.size_txt,
	output:
		hic_pro_resluts = "results/02_assembly/03_hic/06_End_hic/{sample}_hicPro/hic_results/matrix/{sample}/iced/1000000/{sample}_1000000_iced.matrix"
	threads:
		64
	params:
		ref_prefix = "{sample}",
		hic_data = "cleandata/03_hic/{sample}",
		ref = "/public1/home/sca2822/SolanaceaeGenomeAnalyze/00_GenomeAssembly/00_AssemblyResult/01_hifi_hic/clean_genome/{sample}/refenrence/"+ref,
		hic_data_dir = "cleandata/03_hic",
		hic_resluts_dir = "results/02_assembly/03_hic/06_End_hic/{sample}_hicPro",
		hic_pro_config = "results/02_assembly/03_hic/06_End_hic/config-hicpro.txt"
	shell:
		"""
		rm -r results/02_assembly/03_hic/06_End_hic/{params.ref_prefix}_hicPro
		mkdir -p {params.hic_data}
		ln -s ../{params.ref_prefix}_clean_1.fq.gz {params.hic_data}/{params.ref_prefix}_clean_R1.fastq.gz
		ln -s ../{params.ref_prefix}_clean_2.fq.gz {params.hic_data}/{params.ref_prefix}_clean_R2.fastq.gz
		ln -s {params.ref} results/02_assembly/03_hic/06_End_hic/
		singularity exec GenomeAssemblyContainer_v0.2 \
		HiC-Pro -i {params.hic_data_dir} -o {params.hic_resluts_dir} -c {params.hic_pro_config}
		"""



























