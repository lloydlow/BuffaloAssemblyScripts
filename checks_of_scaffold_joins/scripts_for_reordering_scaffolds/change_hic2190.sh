#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

#gaps are taken out from all pieces
samtools faidx hic2190_ch2100_ScimKQY_30.fa hic2190_ch2100_ScimKQY_30:1-34492873 > 1st_piece
samtools faidx hic2190_ch2100_ScimKQY_30.fa hic2190_ch2100_ScimKQY_30:34493874-42096621 > 2nd_piece
samtools faidx hic2190_ch2100_ScimKQY_30.fa hic2190_ch2100_ScimKQY_30:42097622-124922443 > 3rd_piece

#####WRONG REV
#seqkit seq -r 2nd_piece > tmp
#printf "%s\t%s\n" "hic11_ch3004_ScimKQY_3.fa" "+" >> contig_order.list
#printf "%s\t%s\n" "1st_piece" "+" >> contig_order.list
#printf "%s\t%s\n" "tmp" "+" >> contig_order.list
#printf "%s\t%s\n" "3rd_piece" "+" >> contig_order.list

printf "%s\t%s\n" "hic11_ch3004_ScimKQY_3.fa" "+" >> contig_order.list
printf "%s\t%s\n" "1st_piece" "+" >> contig_order.list
printf "%s\t%s\n" "2nd_piece" "-" >> contig_order.list
printf "%s\t%s\n" "3rd_piece" "+" >> contig_order.list

java -jar -Xmx15000m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4009.fa" -p 1000

rm tmp

sed 's/^>merged/>hic4009/g' hic4009.fa > tmp; mv tmp hic4009.fa

