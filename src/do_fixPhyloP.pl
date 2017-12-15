#!/usr/bin/perl
use strict;
use 5.010;
use warnings;

if(@ARGV==0) {
print "Usage: perl $0 <(paste TFBS_2bp.bed0 TFBS_2bp.bed TFBS_2bp.ppe)\n";
exit;
}

# 0
#Chr1    3138    3163    AT3G27010       7.46e-06        +       TTTGCTTTGGGAGGGACCCAT
# 7
#Chr1    3138    3163    AT3G27010       7.46e-06        +       TTTGCTTTGGGAGGGACCCAT
# 14
#Scaffold_1      5252    5271    AA31G00850      8.59e-06        +       GTTTTTGACTTTTTT 0.529446647100049 -0.206807486869013 0.71667

open my $FILE , $ARGV[0];
while(<$FILE>) {
	chomp;
	my @lines = split(/\t/ , $_);
	my $strand = $lines[5];
	my $fixl = $lines[8] - $lines[1];
	my $fixr = $lines[2] - $lines[9];
	my @flanks = split(/ / , $lines[21]);
	my $len = @flanks;

	if( ($fixl>0) && ($fixr>0) ) {
		print STDERR "Warning: Both sides were truncted.\n";
	} elsif($fixl>0) {	# strat with 0
		my @adds = ("NA") x $fixl;
		if($strand eq "+") {
			unshift @flanks , @adds;
			#@flanks = @flanks[0..($len - 1)];
		} else {
			push @flanks , @adds;
			#@flanks = @flanks[(-$len)..-1];
		}
	} elsif($fixr>0) {	# end with boundary
		my @adds = ("NA") x $fixr;
		if($strand eq "+") {
			push @flanks , @adds;
			#@flanks = @flanks[(-$len)..-1];
		} else {
			unshift @flanks , @adds;
			#@flanks = @flanks[0..($len - 1)];
		}
	} else {
		@flanks = @flanks;
	}
	$lines[21] = join " " , @flanks;
	my $ot = join "\t" , @lines[14..21];
	print "$ot\n";
}


