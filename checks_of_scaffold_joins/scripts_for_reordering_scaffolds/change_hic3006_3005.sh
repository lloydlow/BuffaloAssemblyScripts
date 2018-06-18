#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

######WRONG REV
#seqkit seq -r hic3005_ch345_ScimKQY_126.fa > tmp
#printf "%s\t%s\n" "hic3006_ch237_ScimKQY_126.fa" "+" >> contig_order.list
#printf "%s\t%s\n" "tmp" "+" >> contig_order.list

printf "%s\t%s\n" "hic3006_ch237_ScimKQY_126.fa" "+" >> contig_order.list
printf "%s\t%s\n" "hic3005_ch345_ScimKQY_126.fa" "-" >> contig_order.list

java -jar -Xmx8000m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4003.fa" -p 1000

rm tmp

sed 's/^>merged/>hic4003/g' hic4003.fa > tmp; mv tmp hic4003.fa

