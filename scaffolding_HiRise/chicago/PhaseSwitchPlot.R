#------------------------------------------------------
# Program name: PhaseSwitchPlot.R
# Objective: plot phase switch example
#           
# Author: Lloyd Low
# Email add: lloydlow@hotmail.com
#------------------------------------------------------

library(dplyr,quietly = TRUE)
library(ggplot2,quietly = TRUE)

#read in PacBio cov file
pacbio_cov <- read.delim("CovInChicBreak/figure_maintext/000001F_arrow_arrow_48830932_48880932.cov",header = FALSE, 
                         stringsAsFactors = FALSE)
colnames(pacbio_cov) <- c("Input","POS","cov")
boolean1 <- which(pacbio_cov$POS >= 48830932 & pacbio_cov$POS <= 48880932)
pacbio_cov_Region <- pacbio_cov[boolean1,]
pacbio_cov_Region$Region <- 'diploid'
pacbio_cov_Region$Region[pacbio_cov_Region$POS < 48845000] <- 'haplotype 1'
pacbio_cov_Region$Region[pacbio_cov_Region$POS > 48865000 & pacbio_cov_Region$POS < 48875000] <- 'haplotype 2'

tiff(filename = "PhaseSwitch.tiff",width = 600, height = 600)
p <- ggplot(pacbio_cov_Region, aes(x=POS, y=cov, group=Region))
p <- p + xlab("Position in contig") + ylab("Coverage of mapped PacBio subreads")
p <- p + geom_point(aes(shape=Region, color=Region))
p <- p + geom_vline(xintercept = 48855932,linetype="dotted",col="navy blue")
p <- p + annotate(geom="text", x=48855932+3200, y=63.5, label="breakpoint",color="black")
p
dev.off()
