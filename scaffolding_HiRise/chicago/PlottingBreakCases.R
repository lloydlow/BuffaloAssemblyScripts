#Plot cases of breaks from HiRise
#This script is to investigate how many cases belong to
#Case 1: PacBio coverage seems good but a breakpoint is given by HiRise
#Case 2: Breakpoint in unusually high coverage region by PacBio reads
#Case 3: HiRise breaks at low PacBio coverage region

allbreaks <- read.delim("datafromserver/CovInChicBreak/all108.tsv",header = FALSE)
colnames(allbreaks) <- c("ContigName","lowPacBioCov","highPacBioCov", "normalCov")
test <- rowSums(allbreaks[,2:4])

bothLowHighCov <- rowSums(allbreaks[,2:4])
for (i in 1:length(bothLowHighCov)){
  if (bothLowHighCov[i] == 1) bothLowHighCov[i] <- 0
  else if (bothLowHighCov[i] == 2) {
    bothLowHighCov[i] <- 1
    allbreaks$lowPacBioCov[i] <- 0
    allbreaks$highPacBioCov[i] <- 0
  }
}

allbreaks$bothLowHighCov <- bothLowHighCov

sumCasesCategory <- apply(allbreaks[,2:5],2,sum)
names(sumCasesCategory) <- c("Low PacBio coverage","High PacBio coverage","Normal coverage",
                      "Both high and low coverage")
png("DifferentCovInBreaks.png",width = 800, height = 800)
barplot(sumCasesCategory,col="dark green",ylim = c(0,75))
text(4.3, 5, "3")
text(3.1, 71, "69")
text(1.9, 16, "14")
text(0.7, 24, "22")
dev.off()
