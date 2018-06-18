#!/bin/bash
# an interactive script to join scaffold together

echo "What counter, pacbioname and scaffold?"
read var1 var2 var3

echo Your counter was: $var1
echo Your pacbio name was: $var2
echo Your scaffold name was: $var3

if [ -f contig_order.list ]
then
rm contig_order.list
fi

var6=0

until [ $var6 == "end" ]
do
	echo "What fragment do you like to join (e.g. 000176F_0_3515200.fa +)?"
	read var4 var5
	printf "%s\t%s\n" $var4 $var5 >> contig_order.list
	echo end now?
	read var6
done 

filename3order="ch"$var1"_"$var2"_"$var3".fa"
filename3orderwofa="ch"$var1"_"$var2"_"$var3

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

java -Xmx8000m -jar $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o $filename3order -p 1000
sed "s/^>merged/>$filename3orderwofa/g" < $filename3order > tmp; mv tmp $filename3order 

