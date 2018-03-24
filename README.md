# FunTFBS
FunTFBS is used for identifying transcriptional factor binding sites (TFBS) which have transcriptional regulatory functions. Given a set of candidate TFBS set, for each binding site FunTFBS can filter for functional ones based on the correlation between frequencies in binding motif and conservation scores (the absolute values of PhyloP) across base pairs.

## Prerequisite
1. perl (5.010 or later)
   You can type "perl -v" to check for the version.
2. R (3.0.1 or later)
   You can type "R --version" to check for the version.
3. R package: data.table (1.10.4 or later)
   You can type "library("data.table")" in R environment to check for the version.
   If this package is not installed, just type "install.packages("data.table")" for installation.

## Installation
The "funTFBS" file can be run directly, also you can add this path to PATH environment variable.

export PATH=$PATH:/the path of this package

For testing the program, please run following command line:

funTFBS -t demo/test_TFBS.bed -m demo/Ath.meme -f meme -p demo/test_PhyloP.bed -g demo/Ath_test.fa -o test

If there is no error you will get two files in the "test" fold, which are identical with those in the "demo" fold.
test/TFBS_unfiltered.bed
test/TFBS_filtered.bed

## General usage
funTFBS -t demo/test_TFBS.bed -m demo/Ath.meme -f meme -p demo/test_PhyloP.bed -g demo/Ath_test.fa -o test

        -t [TFBS.bed]  the file containing candidate TFBS in bed format (with strand information)
        -m [motifs]    the file containing binding motifs in specified format.
        -f [format]    the format of bidning motifs, could be one of them:
		       meme/beeml/chen/jaspar-pfm/jaspar-sites/jaspar-cm/transfac/uniprobe.
        -p [phyloP.bg] the file containing PhyloP scores in bedGraph format.
        -g [genome.fa] the file containing genomic sequence in fasta format.
        -o [output]    the output directory.
        -h             show this help information.

Note:
The 4th column of TFBS.bed is used as TF ID, which should be matched with TF ID in the motifs file.

The phyloP.bg should be sorted by coordinate (sort -k 1,1 -k 2,2n).

The candidate TFBS  will be filtered with following cutoff: [correlation score > 0.5] AND [correlation p-value <= 0.05]

After running it there will be two files generated in the output directory, which are in bed6+ format (9 columns).

TFBS_unfiltered.bed: Total candidate TFBS before filtering.
TFBS_filtered.bed: Functional TFBS after filtering.

The header of the output files is:
chromosome  start  end  TF  value(not used)  strand  sequence  correlation(Pearson)  p-value(correlation test)

## Credits
Feng Tian, Jinpu Jin

For more details, please see http://plantregmap.cbi.pku.edu.cn/funtfbs.php

Questions or Comments, please contact: planttfdb@mail.cbi.pku.edu.cn
