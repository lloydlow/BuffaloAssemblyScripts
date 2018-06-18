#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

#gaps are taken out from all pieces
samtools faidx hic2202_ch2076_ScimKQY_80.fa hic2202_ch2076_ScimKQY_80:1-13735879 > 1st_piece
samtools faidx hic2202_ch2076_ScimKQY_80.fa hic2202_ch2076_ScimKQY_80:13736880-65854242 > 2nd_piece

######WRONG REV
#seqkit seq -r 1st_piece > tmp
#printf "%s\t%s\n" "tmp" "+" >> contig_order.list
#printf "%s\t%s\n" "2nd_piece" "+" >> contig_order.list

printf "%s\t%s\n" "1st_piece" "-" >> contig_order.list
printf "%s\t%s\n" "2nd_piece" "+" >> contig_order.list

java -jar -Xmx15000m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4010.fa" -p 1000

rm tmp

sed 's/^>merged/>hic4010/g' hic4010.fa > tmp; mv tmp hic4010.fa

