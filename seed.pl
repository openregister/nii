#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper;
my @names;
my $line;
my @line;
my %value;
my $dir = "nii/tiddlers/nii/";

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

while ($line = <>) {

    chomp($line);
    @line = split /\t/, $line;

    if (!@names) {
        @names = @line;
    } else {
        @value{@names} = @line;

        my $title = trim($value{'Dataset Name'});

        my $filename = $title;
        $filename = lc($filename);
        $filename =~ s/[^\w]+/-/g;
        $filename =~ s/^-*//;
        $filename =~ s/-*$//;
        my $path = $dir . $filename . ".tid";

        my $link = $value{'Link'};

        my $tags = "Dataset";
        for my $name ('Facet 1', 'Facet 2') {
            $tags = $tags . " [[" . trim($value{$name}) . "]]" if $value{$name};
        }

        my $publisher = trim($value{'Publisher'});

        if (!-f $path) {
            print "creating $path\n";
            open(my $f, '>', $path) or die "Could not open '$path' $!";
            print $f "title: $title\n";
            print $f "publisher: $publisher\n";
            print $f "link: $link\n";
            print $f "tags: $tags\n";
            print $f "type: text/vnd.tiddlywiki" . "\n";
            print $f "\n";
            close $f;
        }
    }
}
