#Buff_assembly_Chicago 2.R
#This script is to investigate how 867 unbroken contigs join together
#with 194 broken contigs

#read in *input_breaks.txt
inputBreaks <- read.table("data/water_buffalo_12May2017_XIYn4.input_breaks.txt",
                          stringsAsFactors = FALSE)

#base read in zero-based system
colnames(inputBreaks) <- c("HiRise_Scaffold","Input","StartBaseInput","EndBaseInput",
                           "Strand","StartBaseHiRise","EndBaseHiRise")

#read in *table.txt
table <- read.table("data/water_buffalo_12May2017_XIYn4.table.txt",stringsAsFactors = FALSE)

colnames(table) <- c("HiRise_Scaffold","Input","StartBaseInput","EndBaseInput",
                     "Strand","StartBaseHiRise","EndBaseHiRise")

input.uniq <- c()
#loop thro inputBreaks to get unique char
#store unique char in a vector 
for (i in 1:nrow(inputBreaks)){
  input.uniq <- c(input.uniq,inputBreaks[i,2])
}
input.uniq <- unique(input.uniq)

chicStatus_vec <- c()
scaffold_name <- c()
for (k in 1:nrow(table)){
  selc <- is.element(table[k,2],input.uniq)
  if (selc) chicStatus <- "broken"
  else chicStatus <- "unbroken"
  chicStatus_vec <- c(chicStatus_vec,chicStatus)
  
  #split scaffold name to be appended to a vector
  split_name <- strsplit(table[k,1],";")[[1]][1]
  scaffold_name <- c(scaffold_name,split_name)
}
chicStatus_vec <- as.character(chicStatus_vec)
scaffold_name <- as.character(scaffold_name)
table.new <- cbind(table,chicStatus_vec,scaffold_name,stringsAsFactors = FALSE)

table.scaffoldName.break <- table(table.new$scaffold_name,table.new$chicStatus_vec)
table.scaffoldName.break <- as.data.frame.matrix(table.scaffoldName.break)

joinStatus <- c()
for (l in 1:nrow(table.scaffoldName.break)){
  if (table.scaffoldName.break[l,1] == 0 && table.scaffoldName.break[l,2] == 1) {
    status_vec <- "single_unbroken"
  } else if (table.scaffoldName.break[l,1] == 1 && table.scaffoldName.break[l,2] == 0){
    status_vec <- "single_broken"
  } else if (table.scaffoldName.break[l,1] > 1 && table.scaffoldName.break[l,2] == 0){
    status_vec <- "joined_broken_only"
  } else if (table.scaffoldName.break[l,1] == 0 && table.scaffoldName.break[l,2] > 1){
    status_vec <- "joined_unbroken_only"
  } else if (table.scaffoldName.break[l,1] >= 1 && table.scaffoldName.break[l,2] >= 1){
    status_vec <- "joined_both"
  }
  joinStatus <- c(joinStatus,status_vec)
}

table.scaffoldName.break.join <- cbind(table.scaffoldName.break,joinStatus,stringsAsFactors = FALSE)
library(dplyr)
table.scaffoldName.break.join  <- tbl_df(table.scaffoldName.break.join )
table.join <- table.scaffoldName.break.join %>% filter(joinStatus == "joined_both")

scaffold_name2 <- rownames(table.scaffoldName.break.join)
table.scaffoldName.break.join$scaffold_name <- scaffold_name2

#put the joinstatus to table.new
status2 <- c()
for (m in 1:nrow(table.new)){
  vec <- which(table.scaffoldName.break.join$scaffold_name == table.new$scaffold_name[m])
  joinStatus2 <- table.scaffoldName.break.join$joinStatus[vec]
  status2 <- c(status2,joinStatus2)
}

table.new$status2 <- status2

table.new.joined_unbroken_only <- table.new[table.new$status2 == "joined_unbroken_only",]
table.new.single_unbroken <- table.new[table.new$status2 == "single_unbroken",]
table.new.single_broken <- table.new[table.new$status2 == "single_broken",]
table.new.joined_broken_only <- table.new[table.new$status2 == "joined_broken_only",]
table.new.joined_both <- table.new[table.new$status2 == "joined_both",]

#Output the 1061 fragments that have been labeled on their break and join status
#however, whether the break is to be trusted is not decided.
write.csv(table.new,"Chic_1061_fragments.csv")
