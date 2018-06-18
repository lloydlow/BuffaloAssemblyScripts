#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

#gaps are taken out in the first piece
samtools faidx hic2030_ch3090_ScimKQY_111.fa hic2030_ch3090_ScimKQY_111:1-10148255 > 1st_piece
samtools faidx hic2030_ch3090_ScimKQY_111.fa hic2030_ch3090_ScimKQY_111:10149256-83478948 > 2nd_piece

#####WRONG REV
#seqkit seq -r 1st_piece > tmp
#printf "%s\t%s\n" "tmp" "+" >> contig_order.list
#printf "%s\t%s\n" "2nd_piece" "+" >> contig_order.list

printf "%s\t%s\n" "1st_piece" "-" >> contig_order.list
printf "%s\t%s\n" "2nd_piece" "+" >> contig_order.list

java -jar -Xmx8000m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4005.fa" -p 1000

rm tmp

sed 's/^>merged/>hic4005/g' hic4005.fa > tmp; mv tmp hic4005.fa

