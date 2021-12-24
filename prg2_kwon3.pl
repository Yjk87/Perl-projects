#!/usr/bin/perl

use strict;
use warnings;
srand(time|$$);


# File: prg2_kwon3.pl
# Author: Yongjun Kwon
# Date: 08 October 2020
#
# Purpose: Functionalizing my software from program 1 and extending its capabilities


# the argument list should contain the file name
die "usage: prg2_kwon3.pl filename\n" if scalar @ARGV < 1;

# get the filename from the argument list
my ($filename) = @ARGV;

# Open the file given as the first argument on the command line
open(INFILE, $filename) or die "Can't open $filename\n";


# variable declarations:
my @header = ();		    
my @sequence = ();		    
my $count=0;	           
my @permuted_sequence = ();
my @permutesave = ();


read_fasta(\$filename, \@header, \@sequence, \$count);

stat_fasta(\$filename, \@header, \@sequence, \$count);

permute_fasta (\$filename, \@header, \@sequence, \$count, \@permutesave); 

write_fasta(\$filename, \@header, \@sequence, \$count);

stat_fasta(\$filename, \@header, \@sequence, \$count);



exit;













############################################################
###############         Subroutines        #################
############################################################

#PASS-BY-REFERENCE


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
		$$sequence[$i] =~ s/\s//g;
		print "$$header[$i]\n";
		print "$$sequence[$i]\n\n";
	trimmer (\@sequence);
	}
	return $$count;
}


#WRITE Part
sub write_fasta {
	my ($filename, $header, $sequence, $count ) = @_;
	my $outputfile_permute;
	$$filename =~ s/\.[^.]+$//g;
	$outputfile_permute = "$$filename"."_permute.fsa";
	$$filename = "$$filename"."_permute.fsa";
	for (my $r = 0; $r < $$count; $r++) {
	
	
	unless ( open(OUTPUTFP, ">>$outputfile_permute") ) {
		print "Cannot open file \"$outputfile_permute\" to write to!!\n\n";
		exit;
	}

#	print OUTPUTFP "Report for file $$filename\n\n";
	print OUTPUTFP "PERMUTED $$header[$r]\n";
	print OUTPUTFP "This is the permuted sequence: $$sequence[$r]\n\n";
	}
return $$filename;
}


#STAT Part
sub stat_fasta {
	
	my($filename, $header, $sequence, $count) = @_;
	
	
#joining sequence data in a single string
my $totalseq = join ('',@$sequence);

#remove whitespace for accuracy
$totalseq =~ s/\s//g;

#count
my $ltotalseq = length $totalseq;
print "Total sequence length = $ltotalseq\n";

#finding max by using $_
my $maxseq = 0;
for (@$sequence){
	$maxseq = length($_) if length($_) > $maxseq;
	}
print "Maximum sequence length = $maxseq\n";

#finding min by using $_ as well
my $minseq;
my $minhelp;
for (@$sequence){
	my $help = length($_);
	if (not defined $minhelp or $help < $minseq){
		$minhelp = $help;
		$minseq = length ($_);
	}
}
print "Minimum sequence length = $minseq\n";

#average calculation
my $avgseq = $ltotalseq/$$count;
print "Average sequence length = $avgseq\n";

# remove white space from all sequences
for (my $i = 0; $i < $$count; $i++) {
   $sequence[$i] =~ s/\s//g;
}

#stating number of sequences
print "There are $$count seqences in the file\n\n";

	$$filename =~ s/\.[^.]+$//g;
	my $outputfile = "$$filename.ot";
	unless ( open(OUTPUTF, ">>$outputfile") ) {
		print "Cannot open file \"$outputfile\" to write to!!\n\n";
		exit;
	}
	
    print OUTPUTF "Report for file $$filename.fsa\n\n";
	print OUTPUTF "There are $$count seqences in the file\n";
	print OUTPUTF "Total sequence length = $ltotalseq\n";
	print OUTPUTF "Maximum sequence length = $maxseq\n";
	print OUTPUTF "Minimum sequence length = $minseq\n";
	print OUTPUTF "Average sequence length = $avgseq\n\n";
	
	#my $e = 0;
	for (my $i = 0; $i < $$count; $i++) {
	print "$$header[$i]\n";
	my($a,$t,$c,$g) = 0;
	my $cpg = 0;
	my $ldna = 0;
	my $percA = 0;
	my $percT = 0;
	my $percC = 0;
	my $percG = 0;
	my $percCPG = 0;
	my @acounts = ();
	my @ccounts = ();
	my @gcounts = ();
	my @tcounts = ();
	my @cgcounts = ();
	my @aprops = ();
	my @cprops = ();
	my @tprops = ();
	my @gprops = ();
	my @cgprops = ();
	
	
	
	while ($$sequence[$i] =~ /a/ig) {$a++}
	while ($$sequence[$i] =~ /t/ig) {$t++}
	while ($$sequence[$i] =~ /g/ig) {$g++}
	while ($$sequence[$i] =~ /c/ig) {$c++}
	#while ($sequence =~ /[^acgt]/ig) {$e++}
	while ($$sequence[$i] =~ /cg/ig) {$cpg++}

	$ldna = length $$sequence[$i];

	$percA = (($a / $ldna));
	$percT = (($t / $ldna));
	$percC = (($c / $ldna));
	$percG = (($g / $ldna));
	#my($percE) = (($e / $ldna));
	$percCPG = (($cpg / $ldna)); 
	@acounts = split (/ /, $a);
	@ccounts = split (/ /, $c);	
	@gcounts	= split (/ /, $g);
	@tcounts	= split (/ /, $t);
	@cgcounts = split(/ /, $cpg);
	@aprops	= split (/ /, $percA);
	@cprops	= split (/ /, $percC);
	@gprops	= split (/ /, $percG);
	@tprops	= split (/ /, $percT);
	@cgprops	= split (/ /, $percCPG);

	print "Length: $ldna\n";
	printf "A:@acounts ". "%5.2f \n", @aprops;
	printf "C:@ccounts ". "%5.2f \n", @cprops;
	printf "G:@gcounts ". "%5.2f \n", @gprops;
	printf "T:@tcounts ". "%5.2f \n", @tprops;
	#print "Errors=$e\n";
	printf "CpG:@cgcounts ". "%5.2f \n\n", @cgprops;


	print OUTPUTF "$$header[$i]\n";
	print OUTPUTF "Length: $ldna\n";
	printf OUTPUTF "A:@acounts ". "%5.2f \n", @aprops;
	printf OUTPUTF "C:@ccounts ". "%5.2f \n", @cprops;
	printf OUTPUTF "G:@gcounts ". "%5.2f \n", @gprops;
	printf OUTPUTF "T:@tcounts ". "%5.2f \n", @tprops;
	printf OUTPUTF "CpG:@cgcounts ". "%5.2f \n\n", @cgprops;
}

return $$filename;

}


#need to remove whitespace to get a correct number for min/max length
sub trimmer
{
    my ($sequence) = @_;
    s/\s+//g for @$sequence;
    return @$sequence;
}


#PERMUTE Part
sub permute_fasta {
	my($filename, $header, $sequence, $count,$permutesave) = @_;
	my $outputfile_permute;
	print "Permuting the original string...\n";
	
	for (my $r = 0; $r < $$count; $r++) {
	my @permuted_sequence = split('',$$sequence[$r]);
	print "PERMUTED $$header[$r]\n";
#Utilizing Fisher-Yates Shuffle -- HW3 Ex7-3 Example
	 fisher_yates_shuffle(\@permuted_sequence);
	 my $permuted_sequence=join('',@permuted_sequence);

#For testing purpose
	#print "Permuted Sequence: $sequence[$r]\n\n";
	
	print "This is the permuted sequence: $permuted_sequence\n"; 

	
	push @$permutesave, $permuted_sequence;
#testing purpose
#print "what is inside \@permutesave?: @permutesave\n\n";

	}
	
@$sequence = @$permutesave;
return @$permutesave, @$sequence;

}


sub fisher_yates_shuffle 
{
  my $array = shift;
  my $i;
  for ($i = @$array; --$i;)
  {
    my $j = int rand ($i+1);
    next if $i == $j;
    @$array[$i,$j] = @$array[$j,$i];
  }
  
}

