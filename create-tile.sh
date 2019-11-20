#!/bin/bash
#BATCH -c 64
#SBATCH --mem 720G
#SBATCH -p long,big-mem,normal,express
source /home/tmorova/.bashrc
module load samtools/1.9
samtools view -h -f2 -F3332 /groups/lackgrp/ll_members/tunc/phd/ana-starrseq-lncap-lacklab/analysis/mapping/starrseq-lncap-lib3-cleaned.bam |samtools sort -@10 -m10G -n - | bedtools bamtobed -i - -bedpe > temp.bed
cut -f 1,2,6 temp.bed | sort | uniq | bedtools intersect -a - -b /groups/lackgrp/ll_members/tunc/phd/ana-starrseq-lncap-lacklab/analysis/updated.Validation.bed -u | awk '{print $0 "\t" NR "-tile" }' - | sort -k1,1 -k2,2n  > tile.bed
