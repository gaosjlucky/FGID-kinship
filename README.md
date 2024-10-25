# FGID kinship software

The FGID kinship software is an application specifically designed to operate in conjunction with the FGID Microhaplotype kit for kinship analysis. This software allows users to input genotyping data for microhaplotype (MH) loci from multiple samples simultaneously, thereby enhancing the efficiency of kinship analysis. It features a user-friendly interface and provides accurate kinship results, aiming to deliver effective and convenient services to users with relevant requirements.

## Features

- High Accuracy: The FGID kinship software, when used in conjunction with the __FGID Microhaplotype Kit__, demonstrates superior accuracy in kinship analysis compared to traditional CE-STR panels, particularly for more distant relationships such as half-siblings and first cousins.
- Support for Multiple Application Scenarios: In addition to __kinship analysis__, the software supports various forensic applications, including __Individual identification, Duos testing, Trios testing, Mit analysis__, and __chrY analysis__, addressing a wide range of needs from familial relationships to individual identity verification.
- Convenience: Once downloaded, the software can be used immediately, with minimal requirements for input file formats.
- Efficiency: The software can efficiently process large-scale datasets and analyze multiple MH loci simultaneously. This significantly enhances the capacity to handle extensive data.

## Installation

### Prerequisites

- Windows 10 or later
- Strawberry Perl Microsoft Installer Package (MSI). You can easily download the software MSI in the website: https://strawberryperl.com/ 

### Steps

1. Download the zip file and extract the package to an appropriate directory. It is recommended to use [Bandizip](https://www.bandisoft.com/bandizip/) for the extraction.
2. Double-click `bin/GUIforWindows/FGI-20230414-English.exe` to launch the program for kinship analysis.

## Usage

![1729840735658](https://github.com/user-attachments/assets/8f02c027-d51e-43bd-a4d1-85448105775f)

__Because our FGID kinship software is intended to be utilized in conjunction with the FGID Microhaplotype kit as a MH panel, we have seperated the usage into two parts.__

### Part1: Acquisition of Genotyping Data for 232 MH loci
1. Raw fastq files are generated after sequencing samples with the FGID Microhaplotye kit. It is recommended to use [DNBSEQ G99 platform](https://en.mgitech.cn/Home/Products/reagents_info/id/59.html).
2. Clean fastq files are generated after adapter trimming and quality control. It is recommended to use [SOAPnuke](https://github.com/BGI-flexlab/SOAPnuke), and the parameters are recommended as follows:
3. `.bam` files are generated after aligning the cleaned data to the [hg38](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000001405.40/) using [bwa](https://github.com/lh3/bwa), with `bwa mem` as the recommended alignment algorithm.
4. Genotyping data for 232 MH loci is obtained using [MHTyper](https://github.com/wangle-ifs/MHTyper).
   - In this step, we have modified MHTyper to accommodate `.bam` files obtained from single-end (SE) sequencing. For more information, please refer to the script `WL.main-G2023012.pl`, which represents our modified version.

### Part2: Conducting Kinship Analysis Using the FGID Kinship Software

After the FGID Kinship Software is launched, please select the option for `Kinship analysis`. Specify the file paths to import relevant files, and then click on `running` to perform kinship analysis. You could find the result files in the specified `Result` path.

![image](https://github.com/user-attachments/assets/c895caec-e77d-4e46-95c2-bad4eabdbdf0)

The following files are required for the analysis:

- __Frequency File for `Frequency`__: This file should contain three columns of information: MH loci name, allele combination, and allele combination frequency. You could find the frequency file for Chinese Han Population in `database`.
- __Sample Genotyping File for `Case`__: This file should include four columns of information: sample name, MH loci name, allele combination 1, and allele combination 2.
- __Sample Genotyping File for `Data`__: This file should include four columns of information: sample name, MH loci name, allele combination 1, and allele combination 2.

__Please note the following:__

- The columns within these files should be separated by tabs, and there must be no headers or any supplementary information.
  
Sample genotyping file example:

![图片1](https://github.com/user-attachments/assets/b39bf596-f20a-4e8e-a2ff-d5405dc6555c)

- File paths must not contain spaces, parentheses, or other special characters.
- __Sample Genotyping File for `Case`__ and __Sample Genotyping File for `Data`__ may contain identical samples.

## Others
1. We have provided a script for stimulating data sets for testing. Please refer to `simulate` for more details.
2. The Linux version for the FGID kinship software could be found in `bin`. You could use commond line to run our software in Linux system.
3. The config files could be downloaded in `database` for MH calling using MHTyper. The usage is: `--rs 232.rs.txt --amplicon 232.amplicon.txt --dbSNP 232.dbSNP.txt`.

## Contributing

Contributions are welcome! If you find any issues or have suggestions for new features, please open an issue!

## License

This project is released under [GPLv3](https://en.wikipedia.org/wiki/GNU_General_Public_License).

## Contact

Author: Gao Shengjie

Email: gaoshengjie@genomics.cn

Thank you for using our FGID kinship software! If you have any questions, feel free to reach out.
