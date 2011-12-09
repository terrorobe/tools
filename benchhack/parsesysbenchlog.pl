#!/usr/bin/perl

use strict;
use warnings;


use File::Slurp;

my $foo = read_file('autobench.log');

while ($foo =~ m/(Nov|Dec)\s+(\d+)\s+([^\s]+)\s+GMT\s+2011.*?(\d+\.\d+)Mb\/sec/gism) {
	print "$1/$2/2011 $3,$4\n";

}

#Fri Dec  2 12:49:07 GMT 2011

