#------------------------------------------------------
# Program name: buffalo_NextGenAssembly_20180619_gapLength.R
# Objective: check assembly gap and length of the
#           various versions
# Author: Lloyd Low
# Email add: lloydlow@hotmail.com
#------------------------------------------------------

library(readr)
library(dplyr)
library(ggplot2)

# path to all gapLength results
dir2 <- "/Users/lloyd/Documents/lloyd_2017/Research/RiverBuffalo/buffalo_NextGenAssembly/buffalo_NextGenAssembly/reordering_HiRise_result/fasta_file_order_checkBases_N/"

########## this is for checking most continuous contigs across spp ###########
# reading GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns.rls
path10 <- paste0(dir2,"GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns.rls")

GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns <- read_tsv(path10,col_names = FALSE)
names(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns <- GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns$length)) - 
  sum(as.numeric(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns$gap))

N50(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns)
nrow(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_No_Ns)

# reading GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns.rls
path11 <- paste0(dir2,"GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns.rls")

GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns <- read_tsv(path11,col_names = FALSE)
names(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns <- GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns$length)) - 
  sum(as.numeric(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns$gap))

N50(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns)
nrow(GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns)

# reading cattle_arsucd_chr_only_No_Ns.rls
path12 <- paste0(dir2,"cattle_arsucd_chr_only_No_Ns.rls")

cattle_arsucd_chr_only_No_Ns <- read_tsv(path12,col_names = FALSE)
names(cattle_arsucd_chr_only_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

cattle_arsucd_chr_only_No_Ns <- cattle_arsucd_chr_only_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(cattle_arsucd_chr_only_No_Ns$length)) - 
  sum(as.numeric(cattle_arsucd_chr_only_No_Ns$gap))

N50(cattle_arsucd_chr_only_No_Ns)
nrow(cattle_arsucd_chr_only_No_Ns)

# reading cattle_arsucd_chr_only_ungapped_No_Ns.rls
path13 <- paste0(dir2,"cattle_arsucd_chr_only_ungapped_No_Ns.rls")

cattle_arsucd_chr_only_ungapped_No_Ns <- read_tsv(path13,col_names = FALSE)
names(cattle_arsucd_chr_only_ungapped_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

cattle_arsucd_chr_only_ungapped_No_Ns <- cattle_arsucd_chr_only_ungapped_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(cattle_arsucd_chr_only_ungapped_No_Ns$length)) - 
  sum(as.numeric(cattle_arsucd_chr_only_ungapped_No_Ns$gap))

N50(cattle_arsucd_chr_only_ungapped_No_Ns)
nrow(cattle_arsucd_chr_only_ungapped_No_Ns)

# reading goat_chr_only_No_Ns.rls
path14 <- paste0(dir2,"goat_chr_only_No_Ns.rls")

goat_chr_only_No_Ns <- read_tsv(path14,col_names = FALSE)
names(goat_chr_only_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

goat_chr_only_No_Ns <- goat_chr_only_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(goat_chr_only_No_Ns$length)) - 
  sum(as.numeric(goat_chr_only_No_Ns$gap))

N50(goat_chr_only_No_Ns)
nrow(goat_chr_only_No_Ns)

# reading goat_chr_only_ungapped_No_Ns.rls
path15 <- paste0(dir2,"goat_chr_only_ungapped_No_Ns.rls")

goat_chr_only_ungapped_No_Ns <- read_tsv(path15,col_names = FALSE)
names(goat_chr_only_ungapped_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

goat_chr_only_ungapped_No_Ns <- goat_chr_only_ungapped_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(goat_chr_only_ungapped_No_Ns$length)) - 
  sum(as.numeric(goat_chr_only_ungapped_No_Ns$gap))

N50(goat_chr_only_ungapped_No_Ns)
nrow(goat_chr_only_ungapped_No_Ns)

# reading human_chr_only_No_Ns.rls
path16 <- paste0(dir2,"human_chr_only_No_Ns.rls")

human_chr_only_No_Ns <- read_tsv(path16,col_names = FALSE)
names(human_chr_only_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

human_chr_only_No_Ns <- human_chr_only_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(human_chr_only_No_Ns$length)) - 
  sum(as.numeric(human_chr_only_No_Ns$gap))

N50(human_chr_only_No_Ns)
nrow(human_chr_only_No_Ns)

# reading human_chr_only_ungapped_No_Ns.rls
path17 <- paste0(dir2,"human_chr_only_ungapped_No_Ns.rls")

human_chr_only_ungapped_No_Ns <- read_tsv(path17,col_names = FALSE)
names(human_chr_only_ungapped_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

human_chr_only_ungapped_No_Ns <- human_chr_only_ungapped_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(human_chr_only_ungapped_No_Ns$length)) - 
  sum(as.numeric(human_chr_only_ungapped_No_Ns$gap))

N50(human_chr_only_ungapped_No_Ns)
nrow(human_chr_only_ungapped_No_Ns)
max(human_chr_only_ungapped_No_Ns$length)

# reading water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns.rls
path18 <- paste0(dir2,"water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns.rls")

water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns <- read_tsv(path18,col_names = FALSE)
names(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns <- water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns$length)) - 
  sum(as.numeric(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns$gap))

N50(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns)
NG50(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns)
nrow(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_No_Ns)

# reading water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns.rls
path19 <- paste0(dir2,"water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns.rls")

water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns <- read_tsv(path19,col_names = FALSE)
names(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns <- water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$length)) - 
  sum(as.numeric(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$gap))

N50(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns)
nrow(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns)
max(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$length)
# reading mouse_chr_only_No_Ns.rls
path20 <- paste0(dir2,"mouse_chr_only_No_Ns.rls")

mouse_chr_only_No_Ns <- read_tsv(path20,col_names = FALSE)
names(mouse_chr_only_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

mouse_chr_only_No_Ns <- mouse_chr_only_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(mouse_chr_only_No_Ns$length)) - 
  sum(as.numeric(mouse_chr_only_No_Ns$gap))

N50(mouse_chr_only_No_Ns)
nrow(mouse_chr_only_No_Ns)

# reading mouse_chr_only_ungapped_No_Ns.rls
path21 <- paste0(dir2,"mouse_chr_only_ungapped_No_Ns.rls")

mouse_chr_only_ungapped_No_Ns <- read_tsv(path21,col_names = FALSE)
names(mouse_chr_only_ungapped_No_Ns) <- c("scaffold","nothing","gap","length","perc_gap")

mouse_chr_only_ungapped_No_Ns <- mouse_chr_only_ungapped_No_Ns %>%
  dplyr::select(scaffold,gap,length) %>% arrange(desc(length))

sum(as.numeric(mouse_chr_only_ungapped_No_Ns$length)) - 
  sum(as.numeric(mouse_chr_only_ungapped_No_Ns$gap))

N50(mouse_chr_only_ungapped_No_Ns)
nrow(mouse_chr_only_ungapped_No_Ns)

### Draw overlapping histogram
#https://stackoverflow.com/questions/3541713/how-to-plot-two-histograms-together-in-r?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
#Random numbers
#h2<-rnorm(1000,4)
#h1<-rnorm(1000,6)

h1 <- log10(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$length)
h2 <- log10(goat_chr_only_ungapped_No_Ns$length)

# Histogram Colored (blue and red)
hist(h1, col=rgb(1,0,0,0.5), xlim=c(3,9),ylim=c(0,80),
     breaks=20,main="Histograms of log10 ungapped contig length of goat and buffalo genomes", 
     xlab="Log10 ungapped contig length")
hist(h2, col=rgb(0,0,1,0.5), breaks=20,add=T)
box()

# trying density overlap plot
water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$species <- 'water buffalo'
goat_chr_only_ungapped_No_Ns$species <- 'goat'
human_chr_only_ungapped_No_Ns$species <- 'human'
mouse_chr_only_ungapped_No_Ns$species <- 'mouse'
GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns$species <- 'cattle'
cattle_arsucd_chr_only_ungapped_No_Ns$species <- 'cattle ARS-UCD1.2'

spp_df <- rbind(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns,
                goat_chr_only_ungapped_No_Ns,
                human_chr_only_ungapped_No_Ns,
                mouse_chr_only_ungapped_No_Ns,
                GCA_000003055_5_Bos_taurus_UMD_3_1_chr_only_ungapped_No_Ns,
                cattle_arsucd_chr_only_ungapped_No_Ns)

spp_df_human <- spp_df %>% filter(species != 'goat') %>% filter(species != 'cattle ARS-UCD1.2') %>% 
  filter(species != 'cattle')

spp_df_rumi <- spp_df %>% filter(species != 'human') %>% filter(species != 'mouse') %>% 
  filter(species != 'cattle')

spp_df_buff_cattle <- spp_df %>% filter(species != 'human') %>% filter(species != 'mouse') %>% 
  filter(species != 'cattle') %>% filter(species != 'goat')

spp_df_human_goat_buff <- spp_df %>% filter(species != 'cattle ARS-UCD1.2') %>% filter(species != 'mouse') %>% 
  filter(species != 'cattle')

ggplot(spp_df_human, aes(log10(length), fill = species)) + geom_density(alpha = 0.2)

ggplot(spp_df_rumi, aes(log10(length), fill = species)) + geom_density(alpha = 0.2)

ggplot(spp_df_buff_cattle, aes(log10(length), fill = species)) + geom_density(alpha = 0.2)

#order spp
order_spp <- c("human","goat","water buffalo")
spp_df_human_goat_buff$species <- factor(spp_df_human_goat_buff$species, 
                                         levels = order_spp)

#this plot might go to supp
tiff(filename = "DensityPlotsLength.tiff",width = 600, height = 600)
ggplot(spp_df_human_goat_buff, aes(log10(length), fill = species)) + geom_density(alpha = 0.2) +
  xlab(expression(log[10]*" ungapped contig length")) + ggtitle("Density plots of ungapped contig length distribution") + 
  theme(plot.title = element_text(hjust = 0.5))
dev.off()

#boxplot
spp_df_nocattle <- spp_df %>% filter(species != 'cattle ARS-UCD1.2')


tiff(filename = "UngappedContigLength.tiff",width = 600, height = 600, compression = 'none')
g <- ggplot(spp_df_human_goat_buff, aes(x=as.factor(species),y=(length/1e6)))
g <- g + geom_boxplot(fill="slateblue", alpha=0.5)
g <- g + xlab("Species") + ylab("Ungapped contig length (Mbp)")
g <- g + ggtitle("Ungapped contig length distribution by species") + theme(plot.title = element_text(hjust = 0.5))
g
dev.off()

#stat test
#wilcox.test(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$length,
#            goat_chr_only_ungapped_No_Ns$length)
wilcox.test(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$length,
            goat_chr_only_ungapped_No_Ns$length,alternative = "greater")
wilcox.test(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$length,
            human_chr_only_ungapped_No_Ns$length, alternative = "greater")
#wilcox.test(water_buffalo_20180219_gapf_noMito_arrowRename4_pilon_chr_only_ungapped_No_Ns$length,
#            mouse_chr_only_ungapped_No_Ns$length, alternative = "greater")

#is goat great continuous than human?
wilcox.test(goat_chr_only_ungapped_No_Ns$length,
            human_chr_only_ungapped_No_Ns$length,alternative = "greater")
