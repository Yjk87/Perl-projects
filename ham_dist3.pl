#!/usr/bin/perl
use strict;
use warnings;

#Hamming Distance

my $string1 = "make";
my $string2 = "Mage";
my $lcs

hdist(\$string1,\$string2);

exit;


###########################################
sub hdist
{
	my($string1,$string2) = @_;
	my $ls1 = length($$string1);
	my $ls2 = length($$string2);
	if ($ls1=$ls2)
	{
	my $leng = $ls1;
	my $score = 0;
	
	for (my $i=0;$i<$leng;$i++)
	{
		if (substr($$string1, $i, 1) ne substr ($$string2, $i, 1))
		{
			$score=$score+1;
			#uc($$string1);
			#uc($$string2);
			#if (substr($$string1, $1,1) eq substr($$string2,$i,1))
			#{
			#	$score=$score-0.5;
			#}
			
		}
		
			
	}
	print "Hamming Distance between $$string1 and $$string2 are $score.\n";
	}
	else{
		print "$string1 and $string2 have different length.\n";
		exit;
	}
}


