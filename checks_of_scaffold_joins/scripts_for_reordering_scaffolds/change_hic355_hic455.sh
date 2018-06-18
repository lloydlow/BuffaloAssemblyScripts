#!/bin/sh
#Version 0.1.1

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

if [[ -f contig_order.list ]]; then
rm contig_order.list
fi

printf "%s\t%s\n" "hic355_ch44_ScimKQY_138.fa" "+" >> contig_order.list
printf "%s\t%s\n" "hic455_ch62_ScimKQY_235.fa" "+" >> contig_order.list

java -jar -Xmx8000m $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o "hic4002.fa" -p 1000

#rm tmp

sed 's/^>merged/>hic4002/g' hic4002.fa > tmp; mv tmp hic4002.fa
