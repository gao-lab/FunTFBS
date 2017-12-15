#!/usr/bin/perl
use strict;
use 5.010;
use warnings;

if(@ARGV!=1) {
print "Usage: perl $0 foo.pc0\n";
print "perl $0 \n"; 
exit;
}

#Chr1    2125    2133    AT5G01900       9.64e-06        +       TGGTCAAC        0.7251603784676,0.740808056155921,0.775257557818699,0.780309900293514,0.7726076116324,0.729430345230891,0.628379897761925,0.1790873289497
#Chr1    2294    2315    AT5G62940       6.57e-06        -       AAGATGATGAAAAAGGAACGA   0.050328908271109,0.034906455750738,0.00077389914237009,0.00186467238625462,0.000665727383860436,2.6

open my $FILE , $ARGV[0];
while(<$FILE>) {
	chomp;
	my @lines = split(/\t/ , $_);
	my $strand = $lines[5];
	my $str = $lines[7];
	my @values = split("," , $str);
	
	if($strand eq "-") {

#print "--------------\n";
#print "@values\n";
		@values = reverse @values;
#print "@values\n";
	}
	$lines[7] = join " " , @values;
	my $ot = join "\t" , @lines;
	print "$ot\n";
}

