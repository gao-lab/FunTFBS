#!/usr/bin/perl
use strict;
use 5.010;
use warnings;
#no warnings 'experimental::smartmatch';

if(@ARGV!=2) {
print "Usage: perl $0 mtFreq candidate.bed\n";
print "perl $0 mtFreq.txt Ath_unique_1e-5.bed\n"; 
exit;
}

# read motif frequency
my %mtFreq;
open my $FILE , $ARGV[0];
while(<$FILE>) {
	chomp;
	my @lines = split(/\t/ , $_);
	my $tf = $lines[0];
	$mtFreq{$tf} = $lines[1];
}
close $FILE;

# read candidate binding site positions
# Chr1    3132    3144    AT3G48430       3.03e-05        -       CAAAACAAAGGA
my ($TF , $seq , $seq_len , $mt_len);
my @values;

open my $CAND , $ARGV[1];
while(<$CAND>) {
	chomp;
	my @lines = split(/\t/ , $_);
	$TF = $lines[3];
	$seq = $lines[6];
#print "$TF\t$seq\n";
	@values = split(/ / , $mtFreq{$TF});
#print "@values\n";
	my $n = scalar @values;
	$mt_len = $n / 4;
	
	$seq_len = length($seq);
	if($seq_len != $mt_len) {
		print "ERROR: sequence length ($seq_len) is different from motif length ($mt_len)\n";
		exit;
	}
	&do_extract();
}

# extract values
sub do_extract {
my @elements = split(// , $seq);
my $num;
my $freq;
my @freqs;
for(my $i=0;$i<$seq_len;$i++) {
	given ($elements[$i]) {
		when (/^A$/i) { $num = 0 }
		when (/^C$/i) { $num = 1 }
		when (/^G$/i) { $num = 2 }
		when (/^T$/i) { $num = 3 }
	}
	$freq = $values[ $i * 4 + $num ];
	push @freqs , $freq;
}

print "@freqs\n";

}

