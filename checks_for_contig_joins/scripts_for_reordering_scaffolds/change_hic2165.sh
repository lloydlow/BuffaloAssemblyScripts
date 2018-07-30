#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

#gaps are taken out from all pieces
samtools faidx hic2165_ch2187_ScimKQY_24.fa hic2165_ch2187_ScimKQY_24:1-148091982 > 1st_piece
samtools faidx hic2165_ch2187_ScimKQY_24.fa hic2165_ch2187_ScimKQY_24:148092983-153642720 > 2nd_piece
samtools faidx hic2165_ch2187_ScimKQY_24.fa hic2165_ch2187_ScimKQY_24:153643721-165166337 > 3rd_piece

######WRONG REV
#seqkit seq -r 2nd_piece > tmp
#printf "%s\t%s\n" "1st_piece" "+" >> contig_order.list
#printf "%s\t%s\n" "3rd_piece" "+" >> contig_order.list
#printf "%s\t%s\n" "tmp" "+" >> contig_order.list

printf "%s\t%s\n" "1st_piece" "+" >> contig_order.list
printf "%s\t%s\n" "3rd_piece" "+" >> contig_order.list
printf "%s\t%s\n" "2nd_piece" "-" >> contig_order.list

java -jar -Xmx15000m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4008.fa" -p 1000

rm tmp

sed 's/^>merged/>hic4008/g' hic4008.fa > tmp; mv tmp hic4008.fa

