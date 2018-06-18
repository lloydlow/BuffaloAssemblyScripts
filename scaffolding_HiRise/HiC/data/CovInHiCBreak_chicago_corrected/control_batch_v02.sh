#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1            # number of nodes 
#SBATCH -n 4            # number of cores
#SBATCH --time=03:00:00 # time allocation (D-HH:MM:SS)
#SBATCH --mem=6GB       # memory pool for all cores

module load SAMtools/0.1.19-GCC-5.3.0-binutils-2.25
#module load R/3.3.0-foss-2016uofa 
#module load R/3.2.1-foss-2015b 

./extract_breakpt_sam_v0.1.4.sh breakpt /fast/users/a1223107/newAssembly_HiRise_Chicago/waterbuffalo_Unzip_arrow_primaryContigs/water_buffalo_15May2017_XIYn4/bams/mergedChic.sorted.bam /fast/users/a1223107/newAssembly_pacbio/bamfile/waterbuffalo_Unzip_arrow.bam /fast/users/a1223107/USMARC_NextSeqData/all_buffalo_nextseq_illumina/merge_pContig/merged_Illum_pContig.sorted.bam
