#!/usr/bin/env perl

# seed tiddlers using the hacked spreadsheet

use strict;
use warnings;

use Data::Dumper;
use Text::CSV;

my $dir = $ARGV[1] || "nii/tiddlers/nii/";

sub trim {
    my $s = shift;
    $s =~ s/^\s+//;
    $s =~ s/\s+$//;
    return $s
}

sub tiddler {
    my ($title, $link, $tags, $color, $text) = @_;

    my $filename = $title;
    $filename = lc($filename);
    $filename =~ s/[^\w]+/-/g;
    $filename =~ s/^-*//;
    $filename =~ s/-*$//;
    my $path = $dir . $filename . ".tid";

    if (!-f $path) {
        print "creating $path\n";
        open(my $out, '>', $path) or die "Could not open '$path' $!";
        print $out "title: $title\n";
        print $out "link: $link\n" if $link;
        print $out "tags: $tags\n" if $tags;
        print $out "color: $color\n" if $color;
        print $out "type: text/vnd.tiddlywiki\n";
        print $out "\n";
        print $out $text if ($text);
        close $out;
    }
}

sub tags {
    my $tags = "";
    foreach my $tag (@_) {
        $tag = trim($tag);
        if ($tag =~ /\s/) {
            $tags = $tags . " [[$tag]]";
        } elsif ($tag) {
            $tags = $tags . " $tag";
        }
    }
    return $tags;
}

my $csv = Text::CSV->new({ binary => 1 })
    or die "Cannot use CSV: ".Text::CSV->error_diag();
 
my $in = *STDIN;
my @cols = ();
foreach my $col (@{$csv->getline($in)}) {
    push @cols, trim($col);
}

my %publisher;
my %facet;

$csv->column_names(@cols);
while (my $value = $csv->getline_hr($in)) {

    my $title = trim($value->{'Dataset Name'});
    my $link = trim($value->{'Link'});

    my @tags = ("National Information Infrastructure", "Dataset");
    for my $name ('Facet 1', 'Facet 2') {
        my $f = trim($value->{$name});
        push @tags, $f if $f;
        $facet{$f} = $f;
    }

    my $p = trim($value->{'Publisher'});
    if ($p) {
        push @tags, $p;
        $publisher{$p} = $p;
    }

    tiddler($title, $link, tags(@tags));
}

# tags ..

my $color;
foreach my $facet (keys %facet) {
    my $text = "{{{ [tag[$facet]] }}}";
    my @tags = ("Facet");
    tiddler($facet, undef, tags(@tags), $color, $text);
}

$color = "#000000";
foreach my $publisher (keys %publisher) {
    my $text = "{{{ [tag[$publisher]] }}}";
    my @tags = ("Publisher");
    tiddler($publisher, undef, tags(@tags), $color, $text);
}
