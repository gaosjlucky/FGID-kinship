use strict;
use warnings;
use List::Util 'shuffle';

die "Usage: perl $0 <genotype_file> <numberofmixsamples> <numberofsimulated> <outfile>\n" unless @ARGV == 4;

# 输入参数
my $genotype_file =shift or die $!;
my $num_samples_to_select = shift or die $!; # 从命令行获取样本组合数量
my $target_lines = shift or die $!; # 目标行数
# 读取生成的基因型信息文件
#my $genotype_file = 'genotype_samples.txt'; # 指定基因型信息文件名


my @samples;

# 读取基因型信息
open(my $fh, '<', $genotype_file) or die "Could not open file '$genotype_file': $!";
while (my $line = <$fh>) {
    chomp $line;
    push @samples, [split(/\t/, $line)]; # 每行按制表符分开并存储
}
close($fh);

# 获取样本数量
my $num_samples = scalar @samples;

# 输出结果
my $out=shift  or die $!;
open(my $out_fh, '>', $out) or die "Could not open output file: $!";

my $count = 0;

while ($count < $target_lines) {
    # 随机选择 n 个样本的索引
    my @indices = (shuffle(0 .. $num_samples - 1))[0 .. $num_samples_to_select - 1];

    my %allele_count;

    # 统计选定的 n 个样本的等位基因
    for my $index (@indices) {
        for my $genotype (@{$samples[$index]}) {
            my ($gene, $alleles) = split(/:/, $genotype);
            my ($allele1, $allele2) = split(/\//, $alleles);
            $allele_count{$allele1}++;
            $allele_count{$allele2}++;
        }
    }

    # 输出等位基因个数
    my $sample_pair = "Samples: " . join(", ", @indices);
    my $distinct_count = scalar keys %allele_count;
    print $out_fh "$sample_pair: $distinct_count distinct alleles\n";

    $count++;
}

close($out_fh);
print "已生成 10000 行随机样本组合的等位基因个数，并保存到 'random_allele_counts.txt'\n";
