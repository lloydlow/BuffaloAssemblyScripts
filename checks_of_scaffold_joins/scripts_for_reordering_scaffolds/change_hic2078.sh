#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

#gaps are taken out from all pieces
samtools faidx hic2078_ch339_ScimKQY_125.fa hic2078_ch339_ScimKQY_125:1-23799929 > 1st_piece
samtools faidx hic2078_ch339_ScimKQY_125.fa hic2078_ch339_ScimKQY_125:23800930-102240295 > 2nd_piece

######WRONG REV
#seqkit seq -r 1st_piece > tmp
#printf "%s\t%s\n" "tmp" "+" >> contig_order.list
#printf "%s\t%s\n" "2nd_piece" "+" >> contig_order.list

printf "%s\t%s\n" "1st_piece" "-" >> contig_order.list
printf "%s\t%s\n" "2nd_piece" "+" >> contig_order.list

java -jar -Xmx15000m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4007.fa" -p 1000

rm tmp

sed 's/^>merged/>hic4007/g' hic4007.fa > tmp; mv tmp hic4007.fa

