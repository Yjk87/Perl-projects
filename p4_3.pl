#!/usr/bin/perl

# File: p4_3.pl
# Author: Yongjun Kwon
# Date: 16 November 2020
# Purpose: Read sequences from a FASTA format file using CGI module in Perl
# Based in part on basecounter2.pl by Dr. Jeff Solka

use strict;
use warnings;
use CGI qw(:standard);
use CGI::Carp qw/fatalsToBrowser/;
my $q = CGI->new;
my $url = "/ykwon22/cgi-bin/p4_3.pl";
print header;
print start_html('A Base Counter'),
    h3('A Nucleotide and CpG Island Counter'),
    start_multipart_form, p,
    "Click the button to choose a FASTA file:",
    br, filefield(-name=>'filename'), p,
    reset, submit('submit','Submit File'), hr, end_form;
if (param()) {
    my $filename = $q->param('filename');
	my $filehandle = $q->upload('filename');
	
	
# variable declarations:
my @header = ();		    # array of headers
my @sequence = ();		    # array of sequences
my $count = 0;	           # number of sequences
my $n = -1;	   # index of current sequence


# read whole file into @data array
my @data = <$filehandle>; 

	
   
close $filehandle;

foreach my $element (@data) {
	# read FASTA file
			  
    chomp $element;	# remove training \n from line
		#chomp $buffer;	
	    if ($element =~ /^>/) { 	    # line starts with a ">"
		$n++;			    # this starts a new header
		$header[$n] = $element;	    # save header line
		$sequence[$n] = "";	    # start a new (empty) sequence
	    }
	    else {
		next if not @header;	    # ignore data before first header
		$sequence[$n] .= $element     # append to end of current sequence
	    }

	$count = $n+1;			  # set count to the number of sequences
}

	#Stating filename
	print "Report for file $filename",p;
	
	#Stating number of sequences
	print "There are $count sequences in the file",p;
	
	#Joining sequence data in a single string
	my $totalseq = join ('',@sequence);

	#remove whitespace for accuracy
	$totalseq =~ s/\s//g;

	#count
	my $ltotalseq = length $totalseq;
	print "Total sequence length = $ltotalseq", p;

	#removing whitespace in the array
	#the program returned a bit off number for min/max length without this
	s/\s+//g for @sequence;
	
	#finding max by using $_
	my $maxseq = 0;
	for (@sequence){
		$maxseq = length($_) if length($_) > $maxseq;
		}
	print "Maximum sequence length = $maxseq", p;

	#finding min by using $_ as well
	my $minseq;
	my $minhelp;
for (@sequence){
	my $help = length($_);
	if (not defined $minhelp or $help < $minseq){
		$minhelp = $help;
		$minseq = length ($_);
	}
}
print "Minimum sequence length = $minseq", p;

	#average calculation
my $avgseq = $ltotalseq/$count;
print "Average sequence length = $avgseq", p;
	
# remove white space from all sequences
for (my $i = 0; $i < $count; $i++) {
    $sequence[$i] =~ s/\s//g;
}

#process the sequences
for (my $i = 0; $i < $count; $i++) {
    
my $lsequence = length $sequence[$i];
	print "$header[$i]", br;

#inserted length calc here
	print "Length: $lsequence", br; 

#removing the whole sequence for visibility
#    print "$sequence[$i]";

	my($a,$t,$c,$g) = 0;
	my $cpg = 0;
	my $sequence=$sequence[$i];
	#my $e = 0;
	while ($sequence =~ /a/ig) {$a++}
	while ($sequence =~ /t/ig) {$t++}
	while ($sequence =~ /g/ig) {$g++}
	while ($sequence =~ /c/ig) {$c++}
	#while ($sequence =~ /[^acgt]/ig) {$e++}
	while ($sequence =~ /cg/ig) {$cpg++}

	my($ldna) = length $sequence;

	my($percA) = (($a / $ldna));
	my($percT) = (($t / $ldna));
	my($percC) = (($c / $ldna));
	my($percG) = (($g / $ldna));
	#my($percE) = (($e / $ldna));
	my($percCPG) = (($cpg / $ldna)); 

#Final statement using printf (and excluding non ACGT errors)
	printf "A:$a ". "%5.2f   ",$percA;
	print br;
	printf "C:$c ". "%5.2f   ",$percC;
	print br;
	printf "G:$g ". "%5.2f   ",$percG;
	print br;
	printf "T:$t ". "%5.2f   ",$percT;
	print br;
	#print "Errors=$e\n";
	printf "CpG:$cpg ". "%5.2f   ",$percCPG;
	print p;

}	
	
  
    print hr;
    print address( a({href=>$url},"Click here to submit another file."));
}
print end_html;
exit;

