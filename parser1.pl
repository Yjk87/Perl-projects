#!/usr/bin/perl

use strict;
use warnings;

# the argument list should contain the file name
die "usage: lorem_ipsum.pl filename\n" if scalar @ARGV < 1;

# get the filename from the argument list
my ($filename) = @ARGV;
# Open the file given as the first argument on the command line
open(INFILE, $filename) or die "Can't open $filename\n";


# variable declarations:
my @header = ();		    
my @sequence = ();		    
my $count=0;	           
my @outputsave=();
my $actseq = 'TGTCTGGTAAAGGCCAACAA';
my $actleng= length $actseq;
my $ratio=0;

read_fasta(\$filename, \@header, \@sequence, \$count);
#stat_fasta(\$filename, \@header, \@sequence, \$count);

my $outputfile = "$filename";
	unless ( open(OUTPUTF, ">>$outputfile") ) {
		print "Cannot open file \"$outputfile\" to write to!!\n\n";
		exit;
	}

for (my $i = 0; $i < $count; $i++) {
		$ratio = ((length $sequence[$i])/$actleng);
		if ($ratio > 0.65){
		
		print "This entry contains higher than 65% match!\n";
		print "$header[$i]\n";
		print OUTPUTF "This entry contains higher than 65% match!\n";
		print OUTPUTF "$header[$i]\n";
		
		}
		
		}


exit;

#READ FASTA file
sub read_fasta{
	my ($filename, $header, $sequence, $count)= @_;
	my $n = -1;			    # index of current sequence
	while (my $line = <INFILE>) {
		chomp $line;		    # remove training \n from line
		if ($line =~ /^>/) { 	    # line starts with a ">"
			$n++;			    # this starts a new header
			$$header[$n] = $line;	    # save header line
			$$sequence[$n] = "";	    # start a new (empty) sequence
		}
		else {
		next if not @$header;	    # ignore data before first header
		$$sequence[$n] .= $line     # append to end of current sequence
			}
	}
	$$count = $n+1;			  # set count to the number of sequences
	close INFILE; 
	print "Report for file $$filename\n\n";
	for (my $i = 0; $i < $$count; $i++) {
		#$$sequence[$i] =~ s/\s//g;
		#print "$$header[$i]\n";
		#print "$$sequence[$i]\n\n";
	#trimmer (\@sequence);
	}
	return $$count;
}

sub stat_fasta {
	
	my($filename, $header, $sequence, $count) = @_;
	for (my $i = 0; $i < $$count; $i++) {
		print "$$header[$i]\n";
		$$sequence[$i] =~ /\:(\d+)\-*?/;
		print "first number: $2\n\n";
		$$sequence[$i] =~ /\-(\d+)\s+/;
		print "second number: $2\n\n";
		
		}



}