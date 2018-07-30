#------------------------------------------------------
# Program name: buffalo_NextGenAssembly_gap_synteny_LD.R
# Objective: recheck synteny and LD scoring for tidier
#           code
# Author: Lloyd Low
# Email add: lloydlow@hotmail.com
#------------------------------------------------------

#copy some scripts from *LDjump_gap2.R to here to get gapbed_xlsx
library(xlsx)
library(GenomicRanges)
library(readr)
library(dplyr)

setwd("/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/Synteny_with_cattle")

load("synteny_blast90_length100.Rdata")
load("LD_map_all_gapped.Rdata")

setwd("/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/LD_map")
load("LD_map_all.Rdata")
load("LD_map_all_outlier.Rdata")

setwd("/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/")

#the excel gap start pos has +1 to truly show the start pos of gap
gapbed_xlsx <- read.xlsx2("/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/Synteny_with_cattle/water_buffalo_20171010_hic_break_bedgap.xlsx", 
                          sheetName = "Sheet1", stringsAsFactors = FALSE)
gapbed_xlsx$chr <- gsub("_.*","",gapbed_xlsx$chr)
gapbed_xlsx$start <- as.numeric(gapbed_xlsx$start)
gapbed_xlsx$end <- as.numeric(gapbed_xlsx$end)

#read in water_buffalo_20171010_hic_break_ori_names
ori_name <- read_tsv("water_buffalo_20171010_hic_break_ori_names",col_names = FALSE)

new_name <- gsub("_.*","",ori_name$X1)
new_name <- gsub(">","",new_name)
colnames(ori_name) <- "ori_name"
ori_name$new_name <- new_name
ori_name$ori_name <- gsub(">","",ori_name$ori_name)

gap_ori_name <- c()
for (i in 1:nrow(gapbed_xlsx)){
  for (j in 1:nrow(ori_name)){
    if(gapbed_xlsx$chr[i] == ori_name$new_name[j]){
      gap_ori_name <- c(gap_ori_name,ori_name$ori_name[j])
    }
  }
}
gapbed_xlsx$ori_name <- gap_ori_name

#end of copy LDjump_gap2.R

#start of code to score synteny based on blast results
setwd("/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/waterBuffaloBlastDB/bt_ref_Bos_taurus_UMD_3_1_renamedRick/output_20180615")

synteny_status <- c()
for (i in 1:nrow(gapbed_xlsx)){
  start <- gapbed_xlsx$start[i] - 3000; end <- gapbed_xlsx$end[i] + 3000
  
  leftname <- paste0(gapbed_xlsx$ori_name[i],"_",start,"_",gapbed_xlsx$start[i],"left.blnm6")
  rightname <- paste0(gapbed_xlsx$ori_name[i],"_",gapbed_xlsx$end[i],"_",end,"right.blnm6")
  
  left_DF <- read_tsv(leftname,col_names = FALSE,n_max = 1)
  right_DF <- read_tsv(rightname,col_names = FALSE,n_max = 1)
  
  empty_DF <- nrow(left_DF) != 0 && nrow(right_DF) != 0
  
  if (!empty_DF){chr_equal <- FALSE;strand <- FALSE;align_length <- FALSE;dist <- FALSE}
  else{  
    #it hits same chr?
    left_chr <- left_DF$X2
    right_chr <- right_DF$X2
    chr_equal <- left_chr == right_chr
    
    #it hits same strand?
    strand <- (left_DF$X13 == right_DF$X13) && 
      (sign(left_DF$X7 - left_DF$X8) == sign(right_DF$X7 - right_DF$X8))
    
    #meets min alignment length requirement?
    align_length <- left_DF$X4 > 1000 && right_DF$X4 > 1000
    
    #meets min distance of left and right separation requirement?
    dist <- abs(((right_DF$X9 + right_DF$X10)/2) - ((left_DF$X9 + left_DF$X10)/2)) < 1e6
  }
  
  if (empty_DF && chr_equal && strand && align_length && dist){
    synteny_each <- TRUE
    synteny_status <- c(synteny_status,synteny_each)
  } else{
    synteny_each <- FALSE
    synteny_status <- c(synteny_status,synteny_each)
  }
}

#renamed gapbed_xlsx to include synteny_status
gapbed_synteny <- gapbed_xlsx
gapbed_synteny$synteny <- synteny_status

#Including LD info to region around all gaps
gapbed_Gr <- makeGRangesFromDataFrame(gapbed_xlsx)

LD_map_all_copy <- LD_map_all
name_ori <- names(LD_map_all_copy)
name_ori[1] <- "chr";name_ori[3] <- "start"; name_ori[6] <- "end"

names(LD_map_all_copy) <- name_ori
LDjump_Gr <- makeGRangesFromDataFrame(LD_map_all_copy)

ov_gap_as_query <- findOverlaps(gapbed_Gr,LDjump_Gr)
ov_gap_as_query

#below shows all each gap overlap a unique LDjump
length(unique(queryHits(ov_gap_as_query)))

#gap_dummy_length <- 1:nrow(gapbed_xlsx)

#use below to insert value to gap DF
#selc_insert_LDgap <- gap_dummy_length %in% queryHits(ov_gap_as_query)

LD_map_subj_hits_to_gap <- LD_map_all_copy[subjectHits(ov_gap_as_query),]
LD_map_subj_hits_to_gap$LDGap

LDvalue <- rep(NA,nrow(gapbed_xlsx))
queryHits(ov_gap_as_query)
LDvalue[queryHits(ov_gap_as_query)] <- LD_map_subj_hits_to_gap$LDGap
LDvalue

#0.2747769 #LD outlier
LDvalue_logic <- LDvalue > 0.275

gapbed_synteny$LD_outlier <- LDvalue_logic

table(gapbed_synteny$synteny,gapbed_synteny$LD_outlier)
table(gapbed_synteny$synteny[gapbed_synteny$LD_outlier == FALSE])

#some gaps have no LD value overlapping them
table(gapbed_synteny$synteny[is.na(gapbed_synteny$LD_outlier)])

#not all scaffolds are major scaffolds that account for the 25 buffalo chr
scaffold_major <- c("hic3007","hic3011","hic2047","hic2165","hic2190","hic11","hic2068","hic2150","hic2015",
                    "hic2173","hic2086","hic2078","hic2024","hic3005","hic3006","hic2030","hic3010","hic2009",
                    "hic2019","hic2202","hic2058","hic3008","hic3009","hic3004","hic2089","hic2053","hic355",
                    "hic455","hic2142")

gapbed_synteny_major_scaff <- gapbed_synteny[gapbed_synteny$chr %in% scaffold_major,]

table(gapbed_synteny_major_scaff$synteny,gapbed_synteny_major_scaff$LD_outlier)
table(gapbed_synteny_major_scaff$synteny[gapbed_synteny_major_scaff$LD_outlier == FALSE])

#some gaps have no LD value overlapping them
table(gapbed_synteny_major_scaff$synteny[is.na(gapbed_synteny_major_scaff$LD_outlier)])

#Focus on only suspicious contig/broken contig joins
#i.e. synteny FALSE, LD TRUE
#i.e. synteny FALSE, LD NA
gapbed_synteny_major_scaff_suspect <- gapbed_synteny_major_scaff %>% 
  filter(synteny == FALSE & LD_outlier == TRUE | synteny == FALSE & is.na(LD_outlier)) %>%
  arrange(chr)

setwd("/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly")

#synteny_status for goat
setwd("/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/goatBlastDB/output_20180615")

synteny_status_goat <- c()
for (i in 1:nrow(gapbed_xlsx)){
  start <- gapbed_xlsx$start[i] - 3000; end <- gapbed_xlsx$end[i] + 3000
  
  leftname <- paste0(gapbed_xlsx$ori_name[i],"_",start,"_",gapbed_xlsx$start[i],"left.blnm6")
  rightname <- paste0(gapbed_xlsx$ori_name[i],"_",gapbed_xlsx$end[i],"_",end,"right.blnm6")
  
  left_DF <- read_tsv(leftname,col_names = FALSE,n_max = 1)
  right_DF <- read_tsv(rightname,col_names = FALSE,n_max = 1)
  
  empty_DF <- nrow(left_DF) != 0 && nrow(right_DF) != 0
  
  if (!empty_DF){chr_equal <- FALSE;strand <- FALSE;align_length <- FALSE;dist <- FALSE}
  else{  
    #it hits same chr?
    left_chr <- left_DF$X2
    right_chr <- right_DF$X2
    chr_equal <- left_chr == right_chr
    
    #it hits same strand?
    strand <- (left_DF$X13 == right_DF$X13) && 
      (sign(left_DF$X7 - left_DF$X8) == sign(right_DF$X7 - right_DF$X8))
    
    #meets min alignment length requirement?
    align_length <- left_DF$X4 > 1000 && right_DF$X4 > 1000
    
    #meets min distance of left and right separation requirement?
    dist <- abs(((right_DF$X9 + right_DF$X10)/2) - ((left_DF$X9 + left_DF$X10)/2)) < 1e6
  }
  
  if (empty_DF && chr_equal && strand && align_length && dist){
    synteny_each <- TRUE
    synteny_status_goat <- c(synteny_status_goat,synteny_each)
  } else{
    synteny_each <- FALSE
    synteny_status_goat <- c(synteny_status_goat,synteny_each)
  }
}

setwd("/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly")

#Analysis together with goat
gapbed_synteny$synteny_goat <- synteny_status_goat

gapbed_synteny_major_scaff <- gapbed_synteny[gapbed_synteny$chr %in% scaffold_major,]

write_tsv(gapbed_synteny_major_scaff,
          path = "/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/Synteny_with_cattle/synteny_check_table/gapbed_synteny_major_scaff_20180615.tsv")

table(gapbed_synteny_major_scaff$synteny,gapbed_synteny_major_scaff$LD_outlier)
table(gapbed_synteny_major_scaff$synteny[gapbed_synteny_major_scaff$LD_outlier == FALSE])

#some gaps have no LD value overlapping them
table(gapbed_synteny_major_scaff$synteny[is.na(gapbed_synteny_major_scaff$LD_outlier)])

gapbed_synteny_major_scaff_suspect <- gapbed_synteny_major_scaff %>% 
  filter(synteny == FALSE & LD_outlier == TRUE & synteny_goat == FALSE) %>% 
  arrange(chr)
#filter(synteny == FALSE & LD_outlier == TRUE | synteny == FALSE & is.na(LD_outlier)) %>%

write_tsv(gapbed_synteny_major_scaff_suspect,
          path="/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/Synteny_with_cattle/synteny_check_table/gapbed_synteny_major_scaff_v2_20180615.tsv")
