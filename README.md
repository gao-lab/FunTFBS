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

`export PATH=$PATH:/the path of this package`

## General usage
```
funTFBS -t demo/test_TFBS.bed -m demo/Ath.meme -f meme -p demo/test_PhyloP.bed -g demo/Ath_test.fa -o test

	-t [TFBS.bed]  the file containing candidate TFBS in bed format (with strand information)
	-m [motifs]    the file containing binding motifs in specified format.
	-f [format]    the format of bidning motifs, could be one of them:
	               meme/beeml/chen/jaspar-pfm/jaspar-sites/jaspar-cm/transfac/uniprobe.
	-p [phyloP.bg] the file containing PhyloP scores in bedGraph format.
	-g [genome.fa] the file containing genomic sequence in fasta format.
	-o [output]    the output directory.
	-h             show this help information.
```
**Note:**
1) The 4th column of TFBS.bed is used as TF ID, which should be matched with TF ID in the motifs file.
2) The phyloP.bg should be sorted by coordinate (sort -k 1,1 -k 2,2n).
**Tip:**
Due to the PhyloP file may be very large, it is recommended to split it and run FunTFBS for each chromosome.

After running the example above there will be two files (bed6+ format with 9 columns) generated in the output directory:

- TFBS_unfiltered.bed: Total candidate TFBS before filtering.  
- TFBS_filtered.bed: Functional TFBS after filtering.

The header of the output files:

1. chromosome
2. start
3. end
4. TF
5. value (kept from input file and not used)
6. strand
7. sequence
8. correlation (Pearson)
9. p-value (correlation test)

## Credits
Feng Tian, Jinpu Jin

For more details, please see http://plantregmap.cbi.pku.edu.cn/funtfbs.php

Questions or Comments, please contact: planttfdb@mail.cbi.pku.edu.cn

