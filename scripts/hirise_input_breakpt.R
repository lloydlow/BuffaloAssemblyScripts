#hirise_input_breakpt.R
#Generate breakpt filetable for samtools to view breakpt
#read in *input_breaks.txt
inputBreaks <- read.table("data/water_buffalo_12May2017_XIYn4.input_breaks.txt",stringsAsFactors = FALSE)

#base read in zero-based system
colnames(inputBreaks) <- c("HiRise_Scaffold","Input","StartBaseInput","EndBaseInput",
                           "Strand","StartBaseHiRise","EndBaseHiRise")

input.uniq <- c()
#loop thro inputBreaks to get unique char
#store unique char in a vector 
for (i in 1:nrow(inputBreaks)){
  input.uniq <- c(input.uniq,inputBreaks[i,2])
}
input.uniq <- unique(input.uniq)

#loop thro each row in inputbreaks, if Input that matches unique char, extract StartBaseInput and EndBaseInput
#push them into an empty vector, find duplicate number, only use duplicate number and store it
#based on how many duplicated numbers (for loop on duplicated number vector), 
#output Input and duplicated number as a row to an empty DF

library(dplyr)
inputBreaks <- tbl_df(inputBreaks)
# for (k in 1:length(input.uniq)){
#   char1 <- input.uniq[k]
#   df1 <- filter(inputBreaks,Input == char1)
#   vec <- as.integer()
#   for (l in 1:nrow(df1)){
#     vec[l] <- df1[l,3]
#     vec[l + 1] <- df1[l,4]
#     # vec1 <- df1[l,3]
#     # vec1 <- as.integer(vec1)
#     # vec2 <- df1[l,4]
#     # vec2 <- as.integer(vec2)
#     # vec <- c(vec1,vec2)
#   }
# }

DF <- data.frame(a = character(),b = integer(), c = integer())
inputBreaks.ref <- inputBreaks[,2:4]
for (m in 1:nrow(inputBreaks.ref)){
  if (m == 1) {
    RefName <- inputBreaks.ref$Input[1]
    RefEndpt <- inputBreaks.ref$EndBaseInput[1]
    DF <- rbind(DF,inputBreaks.ref[1,])
    next()
  } 
  if (m == nrow(inputBreaks.ref)) next()
  else {
   currentRowRefName <- inputBreaks.ref$Input[m]
   nextRowRefName <- inputBreaks.ref$Input[m+1]
   if (currentRowRefName == RefName && currentRowRefName != nextRowRefName) next()
   if (currentRowRefName != RefName && currentRowRefName == nextRowRefName) {
     RefName <- inputBreaks.ref$Input[m]
     DF <- rbind(DF,inputBreaks.ref[m,])
   }else {
     RefName <- inputBreaks.ref$Input[m]
     DF <- rbind(DF,inputBreaks.ref[m,])
   }
  }
}

difference <- inputBreaks$EndBaseInput - inputBreaks$StartBaseInput
min(difference)

DF <- DF[,c(1,3)]
DF$breakptleft25k <- DF$EndBaseInput - 25000
DF$breakptright25k <- DF$EndBaseInput + 25000

#write out the breakpts
write.table(DF,file = "breakpt", sep = "\t", row.names = FALSE, col.names = FALSE)
