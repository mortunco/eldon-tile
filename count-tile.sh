echo $1
samtools view -bG2048 $1 | samtools sort -@ 9 -m 10G -n - | \
bedtools bamtobed -i - -bedpe | awk '{print $1 "\t" $2 "\t" $6 "\t" $7}' - | \
awk '$3-$2 < 1000 && $3 > $2 {print $0}' - | sort -k1,1 -k2,2n - | \
bedtools intersect -wa -c -f 1 -r -a dev/lib-fragments.bed -b - > $1\.fragment-counts.bed
