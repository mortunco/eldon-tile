#!/bin/bash
#BATCH -c 64
#SBATCH --mem 720G
#SBATCH -p long,big-mem,normal,express
source /home/tmorova/.bashrc
samtools view -b -F 3332 -f2 /groups/lackgrp/ll_members/tunc/phd/ana-starrseq-lncap-lacklab/analysis/mapping/starrseq-lncap-lib3-cleaned.bam | \
samtools sort -@ 15 -m 40G -n - | \
samtools fixmate -m -r - lncap-lib-fixmated.bam 
samtools sort -@ 15 -m 40G lncap-lib-fixmated.bam > tmp.bam 
samtools markdup -r tmp.bam lncap-lib-fixmated-markdupremoved.bam 
samtools sort -@ 15 -m 40G -n lncap-lib-fixmated-markdupremoved.bam | bedtools bamtobed -i - -bedpe  > temp
awk '{print $1 "\t" $2 "\t" $6 "\t" $7}' temp  > lib-fragments.bed
awk '$3-$2 < 1000 && $3 > $2 {print $0}' lib-fragments.bed | sort -k1,1 -k2,2n - > tmp && mv tmp lib-fragments.bed
bedtools intersect -a lib-fragments.bed -b /home/tmorova/STARR/coverage/ValidationRegions_ARBS-NControl-PControl.bed -wa > tmp && mv tmp lib-fragments.bed
rm tmp.bam lncap-lib-fixmated.bam lncap-lib-fixmated-markdupremoved.bam
