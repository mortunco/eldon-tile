#!/bin/bash
echo $1 $2
#$1 input bam
#$2 target library fragment bed
samtools view -b -f2 -F3332 $1 | samtools sort -@ 9 -m 10G -n - | \
bedtools bamtobed -i - -bedpe | awk '{print $1 "\t" $2 "\t" $6 "\t" $7}' - | sort -k1,1 -k2,2n - | \
bedtools intersect -wa -c -f 1 -r -a $2 -b - 
