



#################################      Index      ###########################
rule index_bowtie:
	input:
		ref = 
	output:
		bowtie_index = "{sample}.rev.1.bt2"
	threads:
		60
	params:
		prefix = {wildcards.sample}
	shell:
		"""
		bowtie2-build --threads {threads} -f {input.ref} {params.prefix}
		"""


rule digest:
	input:
		ref =
	output:
		digest_txt = "{sample}_MboI.txt"
	shell:
		"""
		digest_genome.py -r ^GATC -o {output.digest_txt} {input.ref}
		"""

rule samtools_faidx:
	input:
		ref = 
	output:
		fai_index = "{sample}.fasta.fai"
	shell:
		"""
		samtools faidx {input.ref}
		"""


rule fai2size:
	input:
		fai_index = rules.samtools_faidex.output.fai_index
	output:
		size_txt = "{sample}.fasta.size"
	shell:
		"""
		awk '{{print $1"\t"$2}}' {input.fai_index}
		"""




################################    HicPro    #############################
rule hic_pro:
	input:
		hic_data = 
	output:
		hic_pro_resluts = 
	params:
		hic_resluts_dir = "{sample}_hicPro"
		hic_pro_config = 
	shell:
		"""
		HiC-Pro -i {input.hic_data} -o {params.hic_resluts_dir} -c {params.hic_pro_config}
		"""



























