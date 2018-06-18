#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1            # number of nodes 
#SBATCH -n 2            # number of cores
#SBATCH --time=01:00:00 # time allocation (D-HH:MM:SS)
#SBATCH --mem=6GB       # memory pool for all cores

module load SAMtools/1.3.1-GCC-5.3.0-binutils-2.25 

#samtools faidx water_buffalo_20170830_chic_break.fasta 

samtools faidx water_buffalo_20170830_chic_break.fasta ch2007_000037F_ScXIYn4_123:21521274-21571274 > ch2007_000037F_ScXIYn4_123_21521274_21571274.fa

samtools faidx water_buffalo_20170830_chic_break.fasta ch2158_000212F_ScXIYn4_710:16522564-16572564 > ch2158_000212F_ScXIYn4_710_16522564_16572564.fa

samtools faidx water_buffalo_20170830_chic_break.fasta ch3028_000020F_ScXIYn4_257:14284644-14334644 > ch3028_000020F_ScXIYn4_257_14284644_14334644.fa

samtools faidx water_buffalo_20170830_chic_break.fasta ch3122_000124F_ScXIYn4_658:6364183-6414183 > ch3122_000124F_ScXIYn4_658_6364183_6414183.fa

samtools faidx water_buffalo_20170830_chic_break.fasta ch3122_000124F_ScXIYn4_658:53997504-54047504 > ch3122_000124F_ScXIYn4_658_53997504_54047504.fa

samtools faidx water_buffalo_20170830_chic_break.fasta ch3130_000063F_ScXIYn4_695:15811491-15861491 > ch3130_000063F_ScXIYn4_695_15811491_15861491.fa

