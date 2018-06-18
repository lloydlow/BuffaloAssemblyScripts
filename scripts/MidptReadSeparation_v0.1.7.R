#!/usr/bin/env Rscript
#VERSION 0.1.7
#implement read in the Illumina prev assembly cov
#run with MidptReadSeparationLoop_v3.sh
#introduced illcovFile as 7th argument

#0.1.6
#Implement changes to deal with MAPQ >= 50 as per HiRise.
#run with MidptReadSeparationLoop_v2.sh
#Call for the three cases to accept break or not

#0.1.5
#This modification is to make it work on my local Mac since phoenix R doesnt support X11
#this script is ran by MidptReadSeparationLoop.sh 

#0.1.4
#read cov file from pacbio
#the counting of at leat 5 mapped reads is deleted

#0.1.3
#count if at least 10 consecutive less than 5 mapped reads present in the window (e.g. 25kb left and right from
#breakpt)
#script for Rscript version and test on RStudio easily switched by commenting relevant arguments

#0.1.2
#MidptReadSeparation.R to take in 6 arguments 
#1.fullpath sam file
#2.prefix fasta name appended to .png output 
#3 breakpoint coordinate 
#4 left coordinate 
#5 right coordinate
#6 fullpath fasta file

#0.1.1
#MidptReadSeparation.R takes a window of SAM coordinates output from
#extract_breakpt_sam.sh and plot read separation vs read midpoint for PE reads that
#fall within the window

#Rscript version
args <- commandArgs(TRUE)
samFile <- args[1]
figure.name <- paste0(args[2],".png")
prefix <- args[2]
breakpoint = as.numeric(args[3])
x.lower.limit <- as.numeric(args[4])
x.upper.limit <- as.numeric(args[5])
# fastafile <- args[6] #fasta file not needed anymore
covFile <- args[6]
illcovFile <- args[7]

#zoom in
#x.lower.limit <- x.lower.limit + 20000
#x.upper.limit <- x.upper.limit - 20000

# #testing on RStudio
#samFile <- "data/000001F_arrow_arrow_48830932_48880932.sam"
#figure.name <- paste0("000001F_arrow_arrow",".png")
#prefix <- "000001F_arrow_arrow"
#breakpoint = 48855932
#x.lower.limit <- 48830932
#x.upper.limit <- 48880932
##fastafile <- "data/000001F_arrow_arrow_48830932_48880932.fa"
#covFile <- "data/000001F_arrow_arrow_48830932_48880932.cov"

#Read and put headers for sam file
output.sam <- read.delim(samFile,header = FALSE)
names(output.sam) <- c("QNAME","FLAG","RNAME","POS","MAPQ","CIGAR","RNEXT","PNEXT","TLEN")

library(dplyr,quietly = TRUE)
output.sam <- tbl_df(output.sam)
#remove single end PE from this window of coordinates
selc <- duplicated(output.sam$QNAME)
output.sam <- output.sam[selc,]

#filter MAPQ 50, #filter RNEXT is '=' i.e. on the same contig
#then calculate (PNEXT + POS)/2 to get read mid point
output.fil.sam <- output.sam %>% filter(MAPQ >= 50,RNEXT == "=") %>%
  mutate(readPairSeparation = abs(TLEN),readMidpt = (POS + PNEXT)/2)

#read in fasta file and find lowercase (less than 5 pacbio mapped reads) positions
#x <- readLines(fastafile)
#y <- strsplit(x,"")[[2]] #list[[1]] is the fasta header
#is.upper <- "[A-Z]"
#result <- grepl(pattern = is.upper, y)
#result <- as.numeric(result)
#x.axis <- x.lower.limit:x.upper.limit

#options(bitmapType='cairo')
png(filename = figure.name)
par(mfrow = c(3,1))
#plot read separation vs read midpoint for PE reads
plot(output.fil.sam$readMidpt,log10(output.fil.sam$readPairSeparation),xlab = "Read Mid Point",
     ylab = "log10(Read pair separation)",xlim=c(x.lower.limit,x.upper.limit),
     ylim = c(0,range(log10(output.fil.sam$readPairSeparation))[2]))
abline(v=breakpoint,col="blue",lwd=1.5,lty="dashed")

#plot 5 reads mapping or not vs read position
#plot(x.axis,result,type = "l",xlab = "Position",ylab = "At least 5 raw reads mapped")
#abline(v=breakpoint,col="blue",lwd=1.5,lty="dashed")

#read in PacBio cov file
pacbio_cov <- read.delim(covFile,header = FALSE, 
                         stringsAsFactors = FALSE)
colnames(pacbio_cov) <- c("Input","POS","cov")
boolean1 <- which(pacbio_cov$POS >= x.lower.limit & pacbio_cov$POS <= x.upper.limit)
pacbio_cov_region <- pacbio_cov[boolean1,]
plot(pacbio_cov_region$POS,pacbio_cov_region$cov,type = "l",xlab = "Position",
     ylab = "PacBio coverage",ylim = c(0,range(pacbio_cov_region$cov)[2]))
abline(v=breakpoint,col="blue",lwd=1.5,lty="dashed")
abline(h=10,col="red",lwd=1.5)

#read in Ill file
ill_cov <- read.delim(illcovFile,header = FALSE, stringsAsFactors = FALSE)
colnames(ill_cov) <- c("Input","POS","cov")
boolean2 <- which(ill_cov$POS >= x.lower.limit & ill_cov$POS <= x.upper.limit)
ill_cov_region <- ill_cov[boolean2,]
plot(ill_cov_region$POS,ill_cov_region$cov,type = "l",xlab = "Position",
     ylab = "Illumina coverage",ylim = c(0,range(ill_cov_region$cov)[2]))
abline(v=breakpoint,col="blue",lwd=1.5,lty="dashed")
abline(h=0,col="dark green",lwd=1.5)
dev.off()

#Three cases analysis
#Case 1: PacBio coverage seems good but a breakpoint is given by HiRise
#Case 2: Breakpoint in unusually high coverage region by PacBio reads
#Case 3: HiRise breaks at low PacBio coverage region 

#Case 2
veryHighCov <- sum(pacbio_cov_region$cov >= 90)
acceptBreakHighCov <- 0
if (veryHighCov >= 10) acceptBreakHighCov <- 1

#Case 3
lowCovBase <- sum(pacbio_cov_region$cov <= 10)
acceptBreakLowCov <- 0
if (lowCovBase>= 10) acceptBreakLowCov <- 1

#Case 1
normCov <- 1
if (acceptBreakHighCov == 1 || acceptBreakLowCov == 1) normCov <- 0

breakStatus <- data.frame(primaryContigname = prefix, lowPacBioCov = acceptBreakLowCov,
                          highPacBioCov = acceptBreakHighCov, Normal=normCov)
breakname <- paste0(prefix,"_break.tsv")
write.table(breakStatus,file = breakname,row.names = FALSE, col.names = FALSE,sep = "\t")
