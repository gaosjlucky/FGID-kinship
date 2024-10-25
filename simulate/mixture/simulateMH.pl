use strict;
use warnings;

# 读取等位基因频率文件
die "Usage: perl $0 <freqfile> <numberofsample>\n" unless @ARGV == 2;

my $freq_file =shift;
my $num_samples = shift; # 随机样本数量

# 存储基因的等位基因及其频率
my %allele_freqs;

# 读取频率文件
open(my $fh, '<', $freq_file) or die "Could not open file '$freq_file': $!";
while (my $line = <$fh>) {
    chomp $line;
    my ($gene, $allele, $freq) = split(/\s+/, $line);
    push @{ $allele_freqs{$gene} }, { allele => $allele, freq => $freq };
}
close($fh);

# 生成样本
open(my $out_fh, '>', 'genotype_samples.txt') or die "Could not open output file: $!";

for (1..$num_samples) {
    my @genotypes;
    for my $gene (keys %allele_freqs) {
        my @alleles = map { $_->{allele} } @{ $allele_freqs{$gene} };
        my @frequencies = map { $_->{freq} } @{ $allele_freqs{$gene} };

        # 生成两个等位基因（二倍体）
        my $allele1 = weighted_random(\@alleles, \@frequencies);
        my $allele2 = weighted_random(\@alleles, \@frequencies);

        # 记录基因名和等位基因
        push @genotypes, "$gene:$allele1/$allele2"; 
    }
    print $out_fh join("\t", @genotypes) . "\n"; # 以制表符分隔基因型
}
close($out_fh);

# 函数：根据频率生成加权随机选择
sub weighted_random {
    my ($options, $weights) = @_;
    my $rand = rand();
    my $sum = 0;

    for my $i (0 .. $#$options) {
        $sum += $weights->[$i];
        return $options->[$i] if $rand < $sum;
    }

    return $options->[-1]; # 防止意外情况，返回最后一个选项
}

print "随机样本二倍体基因型信息已生成到 'genotype_samples.txt'\n";