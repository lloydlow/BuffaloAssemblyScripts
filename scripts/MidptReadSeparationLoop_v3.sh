#!/bin/sh
#VERSION 3
#This script is to complete the MidptReadSeparation plot in R that couldn't be done on phoenix
#MidptReadSeparation_v0.1.7.R is used here to implement counting consecutive low coverage in pacbio reads
#and ill reads

if [[ $# -lt 1 ]] 
then
        echo "USAGE:MidptReadSeparationLoop.sh breakpt" 
        exit 1
fi

#if [[ -f breakpt ]]
#then
#	tr -d '\"' < breakpt > tmp; mv tmp breakpt
#fi

COUNTER=0
while IFS=$'\t' read -r f1 f2 f3 f4
do
	#(e.g. 000001F_arrow_arrow saved to name files)
	#on my Mac, need to excape the pipeline character
	prefixName=`echo $f1 | sed -e 's/\|/\_/g'`
	##breakpt may occur in the same fasta file so counter keep tracks of each breakpt
	COUNTER=`expr $COUNTER + 1`
	##echo "$COUNTER"
	
	#generate Chicago and PacBio "coverage" plot around breakpt ###MODIFIED to ver 8####
	MidptReadSeparation_v0.1.8.R $prefixName"_"$f3"_"$f4".sam" $prefixName $f2 $f3 $f4 $prefixName"_"$f3"_"$f4".cov" $prefixName"_"$f3"_"$f4".ill_cov"
	##rename with counter
	mv $prefixName".png" $prefixName"$COUNTER"".png"
	mv $prefixName"_break.tsv" $prefixName"$COUNTER""_break.tsv"
done < "$1"
