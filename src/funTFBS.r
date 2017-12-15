#!/usr/bin/Rscript
### according to the correlation to filter binding sites
library("data.table")
#library("parallel")

if(length(commandArgs(T))!=4) {
cat("Usage:   Rscript funTFBS.r","\n")
cat("Example: Rscript funTFBS.r demo/test_100_TFBS.bed demo/test_100_mtFreq.txt demo/test_100_phyloP.txt test\n")
q(save="no")
}

file_mytfbs <- commandArgs(trailingOnly = T)[1]
file_mtFreq <- commandArgs(trailingOnly = T)[2]
file_phyloP <- commandArgs(trailingOnly = T)[3]
outdir <- commandArgs(trailingOnly = T)[4]

#cl <- makeCluster(getOption("cl.cores", 10))

###
do_test <- function() {
  file_mytfbs <- "test_100_TFBS.bed"
  file_mtFreq <- "test_100_mtFreq.txt"
  file_phyloP <- "test_100_phyloP.txt"
  outdir <- "test"
}
###

mytfbs <- fread(file = file_mytfbs,header = F,sep = "\t",stringsAsFactors = F)
mtFreq <- fread(file = file_mtFreq,header = F,sep = "\t",stringsAsFactors = F)
phyloP <- fread(file = file_phyloP,header = F,sep = "\t",stringsAsFactors = F)

compin <- data.frame(freq=mtFreq$V1,phyloP=phyloP$V8,stringsAsFactors = F)

#
do_cor_asb <- function(comp,md = "pearson",cutoff = 0.5, flank, absolute = F) { # specific extension for low CV (with constant flank value)
#  out <- parApply(cl,comp,1,function(x) {
  out <- apply(comp,1,function(x) {
    kx <- strsplit(x[1],split = " ")[[1]] # mtFreq
    ky <- strsplit(x[2],split = " ")[[1]] # phyloP (2bp)
    kx[kx=="NA"] <- NA
    ky[ky=="NA"] <- NA
    kx <- as.numeric(kx)
    ky <- as.numeric(ky)
    
    if(absolute) {
      ky <- abs(ky)
    }
    
    kx_cv <- sd(kx)/mean(kx)
    if(kx_cv <= cutoff) { # extension
      kx <- c(flank,flank,as.numeric(kx),flank,flank)
      ky <- ky
    } else {  # no extension
      kx <- kx
      ky <- ky[3:(length(ky)-2)]
    }
    
    kk <- sum( (! is.na(kx)) & (! is.na(ky)) )
    if(kk<3) { kc <- c(NA,NA) } else {
      ka <- cor(kx,ky,use = "complete.obs",method = md)
      kp <- cor.test(kx,ky,method = md)$p.value
      kc <- c(ka,kp)
    }
  })
  return(out) # correlation and p.value
}
#

all_value_mtFreq_phyloPabs_2bp_asBack_pearson <- do_cor_asb(compin,md = "pearson", flank = 0.25,cutoff = 0.5,absolute = T)
cor_value_mtFreq_phyloPabs_2bp_asBack_pearson <- all_value_mtFreq_phyloPabs_2bp_asBack_pearson[1,]
p_value_mtFreq_phyloPabs_2bp_asBack_pearson <- all_value_mtFreq_phyloPabs_2bp_asBack_pearson[2,]

TFBS <- data.frame(mytfbs, cor_value = cor_value_mtFreq_phyloPabs_2bp_asBack_pearson, p_value = p_value_mtFreq_phyloPabs_2bp_asBack_pearson)
write.table(x = TFBS,file = paste0(outdir,"/TFBS_unfiltered.bed"),row.names = F,col.names = F,quote = F,sep = "\t")

TFBS_filtered <- TFBS[ ! is.na(p_value_mtFreq_phyloPabs_2bp_asBack_pearson) & p_value_mtFreq_phyloPabs_2bp_asBack_pearson<=0.05 & cor_value_mtFreq_phyloPabs_2bp_asBack_pearson>0,]

TFBS_filtered$cor_value <- round(TFBS_filtered$cor_value,4)
TFBS_filtered$p_value <- format(x = TFBS_filtered$p_value,digits = 4,scientific = T)

write.table(x = TFBS_filtered,file = paste0(outdir,"/TFBS_filtered.bed"),row.names = F,col.names = F,quote = F,sep = "\t")

