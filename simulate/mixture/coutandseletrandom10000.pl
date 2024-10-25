use strict;
use warnings;
use List::Util 'shuffle';

die "Usage: perl $0 <genotype_file> <numberofmixsamples> <numberofsimulated> <outfile>\n" unless @ARGV == 4;


my $genotype_file =shift or die $!;
my $num_samples_to_select = shift or die $!;
my $target_lines = shift or die $!;

#my $genotype_file = 'genotype_samples.txt';


my @samples;


open(my $fh, '<', $genotype_file) or die "Could not open file '$genotype_file': $!";
while (my $line = <$fh>) {
    chomp $line;
    push @samples, [split(/\t/, $line)];
}
close($fh);


my $num_samples = scalar @samples;


my $out=shift  or die $!;
open(my $out_fh, '>', $out) or die "Could not open output file: $!";

my $count = 0;

while ($count < $target_lines) {

    my @indices = (shuffle(0 .. $num_samples - 1))[0 .. $num_samples_to_select - 1];

    my %allele_count;


    for my $index (@indices) {
        for my $genotype (@{$samples[$index]}) {
            my ($gene, $alleles) = split(/:/, $genotype);
            my ($allele1, $allele2) = split(/\//, $alleles);
            $allele_count{$allele1}++;
            $allele_count{$allele2}++;
        }
    }


    my $sample_pair = "Samples: " . join(", ", @indices);
    my $distinct_count = scalar keys %allele_count;
    print $out_fh "$sample_pair: $distinct_count distinct alleles\n";

    $count++;
}

close($out_fh);
