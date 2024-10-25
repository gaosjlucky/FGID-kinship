use strict;
use warnings;


die "Usage: perl $0 <freqfile> <numberofsample>\n" unless @ARGV == 2;

my $freq_file =shift;
my $num_samples = shift;


my %allele_freqs;


open(my $fh, '<', $freq_file) or die "Could not open file '$freq_file': $!";
while (my $line = <$fh>) {
    chomp $line;
    my ($gene, $allele, $freq) = split(/\s+/, $line);
    push @{ $allele_freqs{$gene} }, { allele => $allele, freq => $freq };
}
close($fh);


open(my $out_fh, '>', 'genotype_samples.txt') or die "Could not open output file: $!";

for (1..$num_samples) {
    my @genotypes;
    for my $gene (keys %allele_freqs) {
        my @alleles = map { $_->{allele} } @{ $allele_freqs{$gene} };
        my @frequencies = map { $_->{freq} } @{ $allele_freqs{$gene} };


        my $allele1 = weighted_random(\@alleles, \@frequencies);
        my $allele2 = weighted_random(\@alleles, \@frequencies);


        push @genotypes, "$gene:$allele1/$allele2"; 
    }
    print $out_fh join("\t", @genotypes) . "\n";
}
close($out_fh);


sub weighted_random {
    my ($options, $weights) = @_;
    my $rand = rand();
    my $sum = 0;

    for my $i (0 .. $#$options) {
        $sum += $weights->[$i];
        return $options->[$i] if $rand < $sum;
    }

    return $options->[-1];
}
