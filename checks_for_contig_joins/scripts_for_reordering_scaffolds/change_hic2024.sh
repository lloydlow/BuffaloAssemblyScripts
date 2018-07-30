#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

#gaps are taken out in all
samtools faidx hic2024_ch3059_ScimKQY_11.fa hic2024_ch3059_ScimKQY_11:93460354-106384663 > 2nd_piece
samtools faidx hic2024_ch3059_ScimKQY_11.fa hic2024_ch3059_ScimKQY_11:1-93459353 > 1st_piece

#seqkit seq -r 2nd_piece > tmp
#printf "%s\t%s\n" "tmp" "+" >> contig_order.list
#printf "%s\t%s\n" "1st_piece" "+" >> contig_order.list

printf "%s\t%s\n" "2nd_piece" "-" >> contig_order.list
printf "%s\t%s\n" "1st_piece" "+" >> contig_order.list

java -jar -Xmx8000m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4004.fa" -p 1000

rm tmp

sed 's/^>merged/>hic4004/g' hic4004.fa > tmp; mv tmp hic4004.fa

