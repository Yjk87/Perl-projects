#!/usr/bin/perl

# Run the program of choice on all .fsa files in a directory tree


use strict;
use warnings;


die "usage: cr6.pl PROGRAM DIRECTORY\n" if scalar @ARGV < 2;
my ($prog, $dir) = @ARGV;

run_program_recursively($prog, $dir);


exit;


sub run_program_recursively {
    my($program, $directory) = @_;
    # Open the directory
    opendir(DIR, $directory) or die "Can't open directory $directory!";
    # Read the directory, ignoring special entries "." and ".."
    my @files = grep (!/^\.\.?$/, readdir(DIR));
    closedir(DIR);

    for my $file (@files) {
        # Get the full path to the file
        my $entry = "$directory/$file";

        # See if the directory entry is a regular file ending in .fsa
        if (-f $entry and $entry =~ /\.txt$/) {
            # give the outfile file the same name
            #  except change .fsa to .$program.out
            my $outfile = $entry;
            $outfile =~ s/\.txt$/.$program\.txt/;

            # run the program on the given file
            print "running program $program for $entry\n";
            system "./$program $entry";
        }

        # If the directory entry is a subdirectory
        elsif( -d $entry) {
            # Here is the recursive call to this subroutine
            run_program_recursively($program, $entry);
        }
    }
}
