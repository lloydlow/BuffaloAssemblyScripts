#!/bin/sh
#VERSION 0.0.1
# Simple script to get fragments that get pieced together in HiRise

if [[ $# -lt 1 ]] ; then
        echo "USAGE: getFragmentPieces.sh Chic_1061_fragments_decideBreak2.tsv "
        exit 1
fi

if [[ -f $1 ]]
then
        tr -d '\"' < $1 > tmp; mv tmp $1
fi

while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
do
        #a counter to increment scaffold id
        #COUNTER=`expr $COUNTER + 1`
        #echo "$COUNTER"

        #step 1 for single_unbroken
        if [ $f10 == 'joined_both' ] || [ $f10 == 'single_broken' ];then
                subregion=`echo $f2 | sed -e 's/\|/\\\|/g'`
                #echo $subregion
                subregionFinal=$subregion":"$f3"-"$f4
                pacbioShortName=`echo $f2 | sed -e 's/_.*//g'`
                filename1=$pacbioShortName"_"$f3"_"$f4".fa"
		#echo $filename1
                command1="samtools faidx water_buffalo_20170830_chic_break.fasta "$subregionFinal" > "$filename1
                eval $command1
               # rm contig_order.list
               # printf "%s\t%s\n" $filename1 $f5 >> contig_order.list
               # filename1order="hic"$COUNTER"_"$pacbioShortName"_"$f9".fa"
               # filename1orderwofa="hic"$COUNTER"_"$pacbioShortName"_"$f9
               # java -jar $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o $filename1order
               # sed "s/^>merged/>$filename1orderwofa/g" < $filename1order > tmp; mv tmp $filename1order
        fi

done < "$1"


