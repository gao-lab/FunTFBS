# FunTFBS
FunTFBS is used for identifying transcriptional factor binding sites (TFBS) which have **transcriptional regulatory functions**. Given a set of candidate TFBS, FunTFBS can filter for functional ones based on the correlation between frequencies in binding motifs (MBF) and conservation scores (the absolute value of PhyloP) across base pairs.

## Prerequisite
1. perl (5.010 or later)  
   You can type `perl -v` to check for the version.
2. R (3.0.1 or later)  
   You can type `R --version` to check for the version.
3. R package: data.table (1.10.4 or later)  
   You can type `library("data.table")` in R environment to check for the version.  
   If this package is not installed, just type `install.packages("data.table")` for installation.
4. Bedtools (2.26.0)  
   You can type `bedtools --version` to check for the version.  
   If this package is not installed, you can download it from [Github](https://github.com/arq5x/bedtools2).
5. The MEME Suite (4.10.0 or later) (optional, only used when motifs are NOT in `meme` format)  
   If this package is not installed, you can download it from [MEME Suite release page](http://meme-suite.org/doc/download.html?man_type=web).

## Installation
The "funTFBS" file can be run directly:

```
./funTFBS
```

Also you can add this path to the PATH environment variable and run it out of directory:

```
export PATH=$PATH:/the path of this package
funTFBS
```

## General usage
```
funTFBS -t TFBS -m motifs -f motif-format -p PhyloP -g genome -o output

	-t [TFBS.bed]  the file containing positions of candidate TFBS in bed format (with strand information).
	-m [motifs]    the file containing binding motifs in specified format.
	-f [format]    the format of bidning motifs, could be one of them:
	               meme/beeml/chen/jaspar-pfm/jaspar-sites/jaspar-cm/transfac/uniprobe.
	-p [PhyloP.bg] the file containing PhyloP scores in bedGraph format.
	-g [genome.fa] the file containing genomic sequence in fasta format.
	-o [output]    the output directory.
	-h             show this help information.
```
**Note:**
1) The 4th column of TFBS.bed is used as TF ID, which should be matched with TF ID in the motifs file.
2) The PhyloP file should be sorted by coordinate (`sort -k 1,1 -k 2,2n`).

**Tip:**
- Due to the PhyloP file may be very large, it is recommended to split it and run FunTFBS for each chromosome.

**Demo:**
```
funTFBS -t demo/test_TFBS.bed -m demo/Ath.meme -f meme -p demo/test_PhyloP.bed -g demo/Ath_test.fa -o test
```
After running the example, there will be two files (bed6+ format with 9 columns) generated in the output directory:

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

For more details, please see http://plantregmap.gao-lab.org/funtfbs_manual.php

Questions or Comments, please contact: planttfdb@mail.cbi.pku.edu.cn

## Citation
Tian, F., Yang, D. C., Meng, Y. Q., Jin, J. & Gao, G. [PlantRegMap: charting functional regulatory maps in plants](https://academic.oup.com/nar/article/48/D1/D1104/5614566). *Nucleic Acids Res* **48**, D1104-D1113 (2020).
