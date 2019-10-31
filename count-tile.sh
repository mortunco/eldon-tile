echo $1 $2
## $1 input bam
## $2 target library fragment bed 
samtools view -b -f2 -F3332 $1 | samtools sort -@ 9 -m 10G -n - | \
bedtools bamtobed -i - -bedpe | awk '{print $1 "\t" $2 "\t" $6 "\t" $7}' - | sort -k1,1 -k2,2n - | \
#awk '$3-$2 < 1000 && $3 > $2 {print $0}' - | sort -k1,1 -k2,2n - | \
bedtools intersect -wa -c -f 1 -r -a $2 -b - > fragment-counts.$1

#bedtools intersect -wa -wb  -f 1 -r -a $2 -b - > fragment-counts.$1
