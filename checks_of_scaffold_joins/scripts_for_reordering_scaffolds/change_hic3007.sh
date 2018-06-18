#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

#gaps are taken out from all pieces
samtools faidx hic3007_ch3127_ScimKQY_127.fa hic3007_ch3127_ScimKQY_127:1-186197305 > 1st_piece
samtools faidx hic3007_ch3127_ScimKQY_127.fa hic3007_ch3127_ScimKQY_127:186198306-202034796 > 2nd_piece

#####FIRST WRONG REV
#seqkit seq -r 2nd_piece > tmp
#printf "%s\t%s\n" "1st_piece" "+" >> contig_order.list
#printf "%s\t%s\n" "tmp" "+" >> contig_order.list

printf "%s\t%s\n" "1st_piece" "+" >> contig_order.list
printf "%s\t%s\n" "2nd_piece" "-" >> contig_order.list

#java -jar -Xmx15500m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4011.fa" -p 1000

#rm tmp

#sed 's/^>merged/>hic4011/g' hic4011.fa > tmp; mv tmp hic4011.fa

