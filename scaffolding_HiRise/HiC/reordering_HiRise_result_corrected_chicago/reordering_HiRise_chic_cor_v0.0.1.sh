#!/bin/sh
#VERSION 0.0.1
#This script is adapted from reordering_HiRise_v0.0.2.sh
#to deal with single_unbroken and joined_unbroken_only

if [[ $# -lt 1 ]] ; then
        echo "USAGE: reordering_HiRise_chic_cor_v0.0.1.sh Chic_1061_fragments_decideBreak2.tsv "
        exit 1
fi

if [[ -f $1 ]]
then
        tr -d '\"' < $1 > tmp; mv tmp $1
fi

COMBINEFASTADIR="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/scripts_derek/CombineFasta/store"

# step 1: use samtools to search for single_unbroken status2 from Chic_1061_fragments_decideBreak
# input assembly strand selection based on column Strand
# rename these files like ch1_pacbio7digits(e.g. 000176F)_hiriseScaffold(e.g. ScXIYn4_116)

COUNTER=0
while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
do
	#a counter to increment scaffold id
        COUNTER=`expr $COUNTER + 1`
        #echo "$COUNTER"

	#step 1 for single_unbroken
	if [ $f10 == 'single_unbroken' ];then
		subregion=`echo $f2 | sed -e 's/\|/\\\|/g'`
		#echo $subregion
		subregionFinal=$subregion":"$f3"-"$f4
		pacbioShortName=`echo $f2 | sed -e 's/_.*//g'`
		filename1=$pacbioShortName"_"$f3"_"$f4".fa"
		command1="samtools faidx water_buffalo_20170830_chic_break.fasta "$subregionFinal" > "$filename1
		eval $command1
		rm contig_order.list
		printf "%s\t%s\n" $filename1 $f5 >> contig_order.list
		filename1order="hic"$COUNTER"_"$pacbioShortName"_"$f9".fa"
		filename1orderwofa="hic"$COUNTER"_"$pacbioShortName"_"$f9
		java -jar $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o $filename1order
		sed "s/^>merged/>$filename1orderwofa/g" < $filename1order > tmp; mv tmp $filename1order
	fi
	
done < "$1"

# step 2: use the joined_unbroken_only column to join pacbio input fasta that fits the HiRise scaffold 
# for e.g. ScXIYn4_23 is joined from 000486F|arrow|arrow and 000122F|arrow|arrow ,both using + strand

# Output joined_unbroken_only table
cat $1 | tr -d '\"' | awk 'BEGIN {FS= "\t"} $10 ~ "joined_unbroken_only" {print $0}' | sort -t$'\t' -k9,9 -k 6,6n > joined_unbroken_only.tsv
cat joined_unbroken_only.tsv | awk 'BEGIN {FS="\t"} {print $9}' | sort -n | uniq > joined_unbroken_only_uniq

getArray() {
    array=() # Create array
    while IFS= read -r line # Read a line
    do
        array+=("$line") # Append line to the array
    done < "$1"
}

COUNTER2=2000
getArray "joined_unbroken_only_uniq"
for e in "${array[@]}"
        do
                rm contig_order.list
                while IFS=$'\t' read -r f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
                do
                        if [ $e == $f9 ];then
                        COUNTER2=`expr $COUNTER2 + 1`
                        #echo $COUNTER2
                        subregion2=`echo $f2 | sed -e 's/\|/\\\|/g'`
                        #echo $subregion2 #unnecessary legacy from original script
                        subregionFinal2=$subregion2":"$f3"-"$f4
                        #echo $subregionFinal2
                        pacbioShortName2=`echo $f2 | sed -e 's/_.*//g'`
                        filename2=$pacbioShortName2"_"$f3"_"$f4".fa"
                        command2="samtools faidx water_buffalo_20170830_chic_break.fasta "$subregionFinal2" > "$filename2
                        eval $command2
                        printf "%s\t%s\n" $filename2 $f5 >> contig_order.list
                        filename2order="hic"$COUNTER2"_"$pacbioShortName2"_"$f9".fa"
                        filename2orderwofa="hic"$COUNTER2"_"$pacbioShortName2"_"$f9
                        #echo $filename2orderwofa
                        fi

                done < "joined_unbroken_only.tsv"

                java -Xmx14000m -jar $COMBINEFASTADIR"/CombineFasta.jar" order -i contig_order.list -o $filename2order -p 1000
                sed "s/^>merged/>$filename2orderwofa/g" < $filename2order > tmp; mv tmp $filename2order
        done

#cleanup
rm joined_unbroken_only_uniq joined_unbroken_only.tsv

# step 3: write the individual procedure for each of the 179 chicago HiRise scaffolds affected by joining
# of broken fragments


