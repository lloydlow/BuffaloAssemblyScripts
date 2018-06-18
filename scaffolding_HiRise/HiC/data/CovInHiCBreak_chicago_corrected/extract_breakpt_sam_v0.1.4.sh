#!/bin/sh
#VERSION 0.1.4
#This version is implemented after Illumina merged *bam from prev assembly was done. 

#0.1.3
#MidptReadSeparation_v0.1.3.R is used here to implement counting consecutive low coverage in pacbio reads
#Used test_breakpt to test this script

#0.1.2
#Extract subregion fasta seqs from splitted PacBio fasta
#Uses extractSubregion.pl that reads 3 args
#args1 fasta filename; args2 start_coor; args3 end_coor
#Folder where PacBio fasta is 
#/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/newAssemblyConflictResolution_PacBio_Chicago/pacbio_fasta 

#0.1.1
#This script extracts breakpts given from hirise_input_breakpt.R output
#Reads in 4 columns line by line and run samtools view to get region
#flanking breakpt identified in HiRise scaffolding
#Output: sam file for the specified start end coordinates

if [[ $# -lt 4 ]] 
then
        echo "USAGE: extract_breakpt_sam breakpt in.Chic.bam in.PacBio.bam in.Ill.bam"
        exit 1
fi

if [[ -f breakpt ]]
then
	tr -d '\"' < breakpt > tmp; mv tmp breakpt
fi

PATH2PACBIO="/fast/users/a1223107/newAssembly_pacbio/bamfile"

PATH2CHIC="/fast/users/a1223107/newAssembly_HiRise_Chicago/waterbuffalo_Unzip_arrow_primaryContigs/water_buffalo_15May2017_XIYn4/bams"

PATH2ILL="/fast/users/a1223107/Illumina_raw_data_prevAssembly/pairedEnd"

#PATH2BUFFASSEMBLYDATA="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/newAssembly_pacbio/analysis_R/Buff_assembly/data"

COUNTER=0
while IFS=$'\t' read -r f1 f2 f3 f4
do
	#(e.g. 000001F_arrow_arrow saved to name files)
	#on my Mac, need to escape the pipeline character
	prefixName=`echo $f1 | sed -e 's/|/_/g'`
	#breakpt may occur in the same fasta file so counter keep tracks of each breakpt
	COUNTER=`expr $COUNTER + 1`
	#echo "$COUNTER"
	#extract coordinates based on breakpt for Chic
	samtools view $2 $f1":"$f3"-"$f4 > $prefixName"_"$f3"_"$f4".sam"
	#remove unnecessary columns in sam file
	cut -d$'\t' -f 1-9 $prefixName"_"$f3"_"$f4".sam" > tmp; mv tmp $prefixName"_"$f3"_"$f4".sam"
	
	#subset pacbio file to get coverage
	samtools view -b $3 $f1":"$f3"-"$f4 > $prefixName"_"$f3"_"$f4"_pb.bam"
	samtools index $prefixName"_"$f3"_"$f4"_pb.bam"
	samtools depth $prefixName"_"$f3"_"$f4"_pb.bam" > $prefixName"_"$f3"_"$f4".cov"
	
	#subset illumina prev assembly to get coverage
	samtools view -b $4 $f1":"$f3"-"$f4 > $prefixName"_"$f3"_"$f4"_ill.bam"
	samtools index $prefixName"_"$f3"_"$f4"_ill.bam"
	samtools depth $prefixName"_"$f3"_"$f4"_ill.bam" > $prefixName"_"$f3"_"$f4".ill_cov"

	#generate Chicago and PacBio "coverage" plot around breakpt
	#MidptReadSeparation_v0.1.4.R $prefixName"_"$f3"_"$f4".sam" $prefixName $f2 $f3 $f4 $prefixName"_"$f3"_"$f4".cov"
done < "$1"
