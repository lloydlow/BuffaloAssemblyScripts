#------------------------------------------------------
# Program name: buffalo_NextGenAssembly_20180610_gapBySpp.R
# Objective: check assembly gaps by chr and spp
#           
# Author: Lloyd Low
# Email add: lloydlow@hotmail.com
#------------------------------------------------------

library(readr)
library(dplyr)
library(ggplot2)
library(easyGgplot2)

# path to all coor results
dir1 <- "/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/gap_genome_analysis/species/gap_coor/"

# reading water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only.coor
path1 <- paste0(dir1,"water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only.coor")

buffalo_coor <- read_tsv(path1,col_names = FALSE)
names(buffalo_coor) <- c("chromosome","start","stop")

buffalo_coor$species <- 'water buffalo'
#buffalo_coor[buffalo_coor$chromosome == "X",1] <- "25"

#buffalo_coor <- buffalo_coor %>% arrange(as.numeric(chromosome))

# reading goat_chr_only.coor
path2 <- paste0(dir1,"goat_chr_only.coor")

goat_coor <- read_tsv(path2,col_names = FALSE)
names(goat_coor) <- c("chromosome","start","stop")

goat_coor$species <- 'goat'

# reading cattle_arsucd_chr_only.coor
path3 <- paste0(dir1,"cattle_arsucd_chr_only.coor")

cattle_arsucd12_coor <- read_tsv(path3,col_names = FALSE)
names(cattle_arsucd12_coor) <- c("chromosome","start","stop")

cattle_arsucd12_coor$species <- 'cattle'

# reading human_chr_only.coor
path4 <- paste0(dir1,"human_chr_only.coor")

human_coor <- read_tsv(path4,col_names = FALSE)
names(human_coor) <- c("chromosome","start","stop")

human_coor$species <- 'human'

# reading mouse_chr_only.coor
path5 <- paste0(dir1,"mouse_chr_only.coor")

mouse_coor <- read_tsv(path5,col_names = FALSE)
names(mouse_coor) <- c("chromosome","start","stop")

mouse_coor$species <- 'mouse'

# reading GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only.coor
path6 <- paste0(dir1,"GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only.coor")

cattle_umd_coor <- read_tsv(path6,col_names = FALSE,col_types = list(col_character(), col_double(),col_double()))
names(cattle_umd_coor) <- c("chromosome","start","stop")

cattle_umd_coor$species <- 'cattle umd3.1'

all_spp_gap <- rbind(buffalo_coor,goat_coor,human_coor)
all_spp_gap_group <- all_spp_gap %>% dplyr::group_by(species,chromosome) %>% summarise(n =n()) %>%
  dplyr::filter(chromosome != 'X1') 
all_spp_gap_group[all_spp_gap_group$chromosome == 'X2',3] <- 232
all_spp_gap_group[all_spp_gap_group$chromosome == 'X2',2] <- 'X'

#order chr
ordered <- c("1","2","3","4","5","6","7","8","9","10","11",
             "12","13","14","15","16","17","18","19","20","21",
             "22","23","24","25","26","27","28","29","X")
all_spp_gap_group$chromosome <- factor(all_spp_gap_group$chromosome, 
                                       levels = ordered)

#order spp
order_spp <- c("human","goat","water buffalo")
all_spp_gap_group$species <- factor(all_spp_gap_group$species, 
                                         levels = order_spp)

#stack barplot
tiff(filename = "NumberOfGapsBySpecies.tiff",width = 600, height = 600)
g <- ggplot(data = all_spp_gap_group, aes(x = species, y = n, fill = chromosome)) + 
  geom_bar(stat = "identity") + ylab("Number of gaps")
g <- g + ggtitle("Number of gaps per chromosome by species") + theme(plot.title = element_text(hjust = 0.5))
g
dev.off()

#histogram of where gap hits
#order chr
orderedbuff <- c("1","2","3","4","5","6","7","8","9","10","11",
             "12","13","14","15","16","17","18","19","20","21",
             "22","23","24","X")
buffalo_coor$chromosome <- factor(buffalo_coor$chromosome, 
                                       levels = orderedbuff)

ggplot2.histogram(data=buffalo_coor, xName= 'start', xtitle="Position",
                  groupName='chromosome', legendPosition="right",
                  faceting=TRUE, facetingVarNames="chromosome",
                  binwidth = 0.1e6,yShowTitle=FALSE,yShowTickLabel=FALSE,
                  hideAxisTicks=TRUE) 
#yShowTickLabel=TRUE, yTickLabelFont=c(5, "plain", "black"),

# ggplot2.histogram(data=goat_coor, xName= 'start', xtitle="Position",
#                   groupName='chromosome', legendPosition="right",
#                   faceting=TRUE, facetingVarNames="chromosome",
#                   binwidth = 0.1e6,yShowTitle=FALSE,yShowTickLabel=FALSE,
#                   hideAxisTicks=TRUE) 
# 
# ggplot2.histogram(data=cattle_arsucd12_coor, xName= 'start', xtitle="Position",
#                   groupName='chromosome', legendPosition="right",
#                   faceting=TRUE, facetingVarNames="chromosome",
#                   binwidth = 0.1e6,yShowTitle=FALSE,yShowTickLabel=FALSE,
#                   hideAxisTicks=TRUE) 
# 
# ggplot2.histogram(data=human_coor, xName= 'start', xtitle="Position",
#                   groupName='chromosome', legendPosition="right",
#                   faceting=TRUE, facetingVarNames="chromosome",
#                   binwidth = 0.1e6,yShowTitle=FALSE,yShowTickLabel=FALSE,
#                   hideAxisTicks=TRUE) 
