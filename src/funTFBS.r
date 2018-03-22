#!/usr/bin/Rscript
### according to the correlation to filter binding sites
library("data.table")
#library("parallel")

if(length(commandArgs(T))!=4) {
cat("Usage: Rscript do_filterTFBS.r ","\n")
cat("       Rscript do_filterTFBS.r demo/test_100_TFBS.bed demo/test_100_mtFreq.txt demo/test_100_phyloP.txt ftout/test\n")
q(save="no")
}

file_mytfbs <- commandArgs(trailingOnly = T)[1]
file_mtFreq <- commandArgs(trailingOnly = T)[2]
file_phyloP <- commandArgs(trailingOnly = T)[3]
outdir <- commandArgs(trailingOnly = T)[4]

#cl <- makeCluster(getOption("cl.cores", 20-1))

###
do_test <- function() {
  file_mytfbs <- "test_100_TFBS.bed"
  file_mtFreq <- "test_100_mtFreq.txt"
  file_phyloP <- "test_100_phyloP.txt"
  outdir <- "ftout/test"
}
###

mytfbs <- fread(file = file_mytfbs,header = F,sep = "\t",stringsAsFactors = F)
mtFreq <- fread(file = file_mtFreq,header = F,sep = "\t",stringsAsFactors = F)
phyloP <- fread(file = file_phyloP,header = F,sep = "\t",stringsAsFactors = F)

compin <- data.frame(freq=mtFreq$V1,phyloP=phyloP$V8,stringsAsFactors = F)

#
do_cor_0bp_abs <- function(comp,md = "pearson") {
  out <- apply(comp,1,function(x) {
    kx <- strsplit(x[1],split = " ")[[1]]
    ky <- strsplit(x[2],split = " ")[[1]]
    kx[kx=="NA"] <- NA
    ky[ky=="NA"] <- NA
    kx <- as.numeric(kx)
    ky <- abs(as.numeric(ky))
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

all_value <- do_cor_0bp_abs(compin,md = "pearson")
cor_value <- all_value[1,]
p_value <-   all_value[2,]

TFBS <- data.frame(mytfbs, cor_value = cor_value, p_value = p_value)
write.table(x = TFBS,file = paste0(outdir,"/TFBS_unfiltered.bed"),row.names = F,col.names = F,quote = F,sep = "\t")

TFBS_filtered <- TFBS[ ! is.na(TFBS$p_value) & TFBS$p_value <= 0.05 & TFBS$cor_value > 0.5, ]	# XXX

TFBS_filtered$cor_value <- round(TFBS_filtered$cor_value,4)
TFBS_filtered$p_value <- format(x = TFBS_filtered$p_value,digits = 4,scientific = T)

write.table(x = TFBS_filtered,file = paste0(outdir,"/TFBS_filtered.bed"),row.names = F,col.names = F,quote = F,sep = "\t")

