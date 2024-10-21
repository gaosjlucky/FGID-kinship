# README

This is a script for simulating family relationships (Fig1) based on a frequency file (excluding complex situations such as mutations). 

- Individuals in the figure without parental information are referred to as **founders**, and their genotypes are determined based on the frequency file. 
- For individuals with parental information, their genotypes are determined by randomly selecting one allele from each of the father's and mother's two alleles.

<img src="https://7niu.lihaicheng.cn/picgo/20240925/15-35-14-e815a1df4af812b2933d1f5ded77c9a1-image-20240925153514644-22efcb.png" alt="image-20240925153514644" style="zoom:50%;" />

​													Fig 1

## dependency

- python
- pandas
- numpy
- tqdm

## usage

```shell
python simulate.py --frequency <file> --num <int> --familys <str> --output <str>
```

![image-20240925153848711](https://7niu.lihaicheng.cn/picgo/20240925/15-38-48-7bdd65ed1879b6e4e0b6a9b4a25e8abd-image-20240925153848711-366c75.png)