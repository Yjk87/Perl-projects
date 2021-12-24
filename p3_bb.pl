#!/usr/bin/perl

#Binf 634 Program Assignment 3
#11/02/2020
#Yongjun Kwon
#
#Updated 11/03/2020 -- both my subroutine and PDL subroutine for power calculation works, 
#                      Made few fixes as well
#Updated 11/03/2020 (10:25AM) -- Without PDL version, cleaned up some codes
#Updated 11/03/2020 (09:30PM) -- Final edit before submission
#
#

use strict;
use warnings;

#matrix to be read and saved from the file
my @mat1 = ();


#main program

print "Please type the filename: ";
my $filename = <STDIN>;
chomp $filename;


#reading matrix from the file
read_matrix (\$filename, \@mat1);


#printing read matrix
print "--------------------------------------------------\n";
print "Matrix from the file:\n";
print_2d(\@mat1);
print "--------------------------------------------------\n";



#multiplying matrices
my @multi_mat = mult_matrix (\@mat1, \@mat1);


#printing multiplied matrix
print "Multiplied matrix: \n";
print_2Darray(\@multi_mat);
print "--------------------------------------------------\n";


#asking user input for the power
print "Type the number of power you want to use in the matrix_power subroutine: ";
my $power = <STDIN>;
chomp $power;


#use of my subroutine to calculate the power of matrix
print "My matrix_power subroutine result: \n";
my @power_mat = matrix_power_mine (\@mat1, \$power);


#printing powered matrix
print_2Darray2(\@power_mat);
print "--------------------------------------------------\n";



exit;













###########################################################################################
################################  subroutine    ###########################################
###########################################################################################

sub read_matrix {
	
	my ($filename, $mat1) = @_;
	
	open (FH, $$filename) or die "Could not open file $$filename!\n\n";

	my @lines = <FH>;
	my $line;
	my $i;
	close FH;
	#my %count = ();

	$i = 0;
for my $line (@lines) {
    $line =~ s/[[:punct:]]//g;
	$line =~ s/[A-Za-z]+//g;
 #   print("\$i is ",$i,"\n");
    my @row = ();
   # $line =~ s/\s+//g;
   $line =~ s/[\r\n]//g;
   # @row = split "", $line;
    @row = split " ", $line;
    
#   print("element by element printing","\n");
#   print($row[0],"\n");
#   print($row[1],"\n");
#   print($row[2],"\n");
#   print("\n\n");
#   
#   print("\$line is","\n");
#   print($line,"\n");
#   print("\$row is","\n");
#   print(@row,"\n");
    $$mat1[$i] = \@row;
    
    $i = $i + 1;
	
}
return @$mat1;
}


sub print_2Darray {
    my ($multi_mat) = @_;
    my $rows = scalar @multi_mat;
    my $cols = scalar @{$multi_mat[0]};
    for (my $i=0; $i < $rows; $i++) {
	   for (my $j=0; $j < $cols; $j++) {
	     printf "%1d ", $multi_mat[$i][$j];
	   }
	   print "\n"; # newline after each row
    }
}

sub print_2Darray2 {
    my ($power_mat) = @_;
    my $rows = scalar @power_mat;
    my $cols = scalar @{$power_mat[0]};
    for (my $i=0; $i < $rows; $i++) {
	   for (my $j=0; $j < $cols; $j++) {
	     printf "%1d ", $power_mat[$i][$j];
	   }
	   print "\n"; # newline after each row
    }
}

sub print_2d {
	my ($mat1)=@_;
	for(my $i = 0; $i <= $#mat1; $i++){
	   for(my $j = 0; $j <= $#{$mat1[$i]} ; $j++){
	      print "$mat1[$i][$j] ";
	   }
	   print "\n";
	}
}

sub mult_matrix {
    my ($r_mat1,$r_mat2)=@_;
    my (@result_mat)=();
    my ($r1,$c1)=mat_dimension($r_mat1);
    my ($r2,$c2)=mat_dimension($r_mat2);

    
    die "matrix 1 has $c1 columns and matrix 2 has $r2 rows>" 
        . " Cannot multiply\n" unless ($c1==$r2);
    for (my $i=0;$i<$r1;$i++) {
        for (my $j=0;$j<$c2;$j++) {
            my $sum=0;
            for (my $k=0;$k<$c1;$k++) {
                $sum+=$r_mat1->[$i][$k]*$r_mat2->[$k][$j];
            }
            
			$result_mat[$i][$j]=$sum;
        }
    }
    
	return @result_mat;
}



sub mat_dimension { 
    my ($r_mat)=@_;
    my $num_rows=@$r_mat;
    my $num_cols=@{$r_mat->[0]};
    ($num_rows,$num_cols);
}

#original matrix_power subroutine
sub matrix_power_mine {
    my ($r_mat1, $power)=@_;
    my (@result_mat)=();
    my ($r1,$c1)=mat_dimension($r_mat1);
       
    die "ERROR: matrix 1 has $c1 columns and $r1 rows>" 
        . " Cannot power\n" unless ($c1==$r1);
	
if ($$power == 0) {
	print "N is 0\n";
	for (my $i=0;$i<$r1;$i++) {
	
		for (my $j=0;$j<$c1;$j++) {
		
			if ($i == $j) {
            
			$result_mat[$i][$j] = 1;
        } else {
            
			$result_mat[$i][$j] = 0;
        }
    }
}
	
}
elsif ($$power == 1) {
	print "N is 1\n";
	for (my $i=0;$i<$r1;$i++) {
	
		for (my $j=0;$j<$c1;$j++) {
		
		$result_mat[$i][$j]=$r_mat1->[$i][$j];
		
		}
	}
	
}
else {
	@result_mat = mult_matrix (\@$r_mat1, \@$r_mat1);

	for (my $l=0; $l < $$power-2;$l++){		
	
		@result_mat = mult_matrix (\@result_mat, \@$r_mat1);
	}
}

return @result_mat;

}


