#!/usr/bin/perl
use strict;
use 5.010;
use warnings;

if(@ARGV!=1) {
print "Usage: perl $0 foo.meme\n";
print "perl $0 Ath.meme\n"; 
exit;
}

#letter-probability matrix: alength= 4 w= 28 nsites= 569 E= 2.0e-539
#  0.261863        0.244288        0.098418        0.395431

my $id;
my $ic = 0;
my @values;
my %motif;

open my $FILE , $ARGV[0];
while(<$FILE>) {
	chomp;
	if(/^MOTIF (\S+)/) {
		$id=$1;
#print "$id\n";
		next;
	}
	if(/^letter-probability/) {
		$ic = 1;
		next;
	}
	if( ($_ eq "") && ($ic == 1) ) {
		$motif{$id} = join " " , @values;
		@values = ();
		$ic = 0;
		next;
	}
	
	if($ic == 1) {
		my $str = $_;
		$str =~ s/ //g;
		my @lines = split(/\t/ , $str);
		push @values , @lines;
	}
}

#my $n = scalar @values;
#my $mt_len = $n / 4;
#print "---------\n";
close $FILE;

foreach my $i (keys %motif) {
	print "$i\t$motif{$i}\n";
}

