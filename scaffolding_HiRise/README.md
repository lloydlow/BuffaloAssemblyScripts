# Scaffolding with HiRise 
## Alignment of proximity-ligation data
Example SNAP aligner command with Chicago data

The SNAP aligner used is a modified one, which is available here https://github.com/robertDT/dt-snap

Important arguments to pass to SNAP aligner "-ku -as -C-+ -tj GATCGATC -mrl 20"

The alignment file will be used for HiRise scaffolding to estimate read pair distance. The source code of HiRise is proprietary and belongs to Dovetail. 

## Chicago breaks and joins analysis
I found instances where HiRise scaffolding program breaks PacBio contigs that seem to have good sequence coverage. One possible explanation for such break is because FALCON-Unzip assembler output contigs that may have phase shift along the linear sequence. As a result of phase shift, one end of a pair of chicago reads may map well but the other end will not map because the haplotype has changed. 

To circumvent the issue with false breaks, I have created custom scripts to check all breakpoints. 

### Categorise how broken and unbroken PacBio contigs are joined
After HiRise scaffolding, there are two input files that will be crucial for contig breaks analysis. The actual buffalo datasets are given in chicago/data folder here.

* *input_breaks.txt
  Tab-delimited table describing positions of breaks made in the input assembly scaffolds. Follows the same format as the table file described below.
* *table.txt
  Tab-delimited table describing positions of input assembly scaffolds in the Hirise scaffolds. The table has the following format:

            1. HiRise scaffold name
            2. Input sequence name
            3. Starting base (zero-based) of the input sequence
            4. Ending base of the input sequence
            5. Strand (- or +) of the input sequence in the scaffold
            6. Starting base (zero-based) in the HiRise scaffold
            7. Ending base in the HiRise scaffold

Run Buff_assembly_Chicago 2.R script with the above two input files. The script will output a csv file that label how broken/unbroken PacBio contigs are joined by HiRise. The original PacBio contigs used for HiRise can either be broken or not. Then the result from HiRise scaffolding can produce the following five outcomes: single_unbroken (514), joined unbroken_only (198), join_both (250), single_unbroken (87) and broken_only (12). The number inside parentheses shows how many of the buffalo contigs belong the each category.

### Create window around breakpoint
Run hirise_input_breakpt.R that takes \*input_breaks.txt as input and output a breakpt file. The file gives the breakpoint position at the centre and left 25 kb and right 25 kb window for samtools to extract the region of interest. An example breakpt output is below:

               Input	Breakpoint	breakptleft25k	breakptright25k
            1. 000001F|arrow|arrow	48855932	48830932	48880932
            2. 000003F|arrow|arrow	15177502	15152502	15202502

Then the next step is to generate PacBio coverage file for each break point chosen window. Additionally, using the SAM file in the chicago aligned data for the same window, the read pair distance could be calculated. The following script in folder CovInChicBreak/ will do this step.

* extract_breakpt_sam_v0.1.3.sh
* MidptReadSeparationLoop_v3.sh
* MidptReadSeparation_v0.1.7.R

Sample datasets are also given in folder CovInChicBreak/

#### Case 1: PacBio coverage seems good but a breakpoint is given by HiRise

The diploid level coverage for the Buffalo dataset is around 60X, so the haploid coverage is about 30X. Breakpoint introduced in a 50 kb window that only has normal coverage is considered as false break. 


#### Case 2: Breakpoint in unusually high coverage region by PacBio reads

I have set coverage more than or equal 90 as high coverage, which is likely due to repeats. Therefore, if a breakpoint is found in a 50 kb window with at least 10 bases having coverage more than 90X coverage, then the break is accepted.

#### Case 3: HiRise breaks at low PacBio coverage region

I have set coverage less than or equal 10 as low coverage. Therefore, if a breakpoint is found in a 50 kb window with at least 10 bases having coverage less than 10X coverage, then the break is accepted.
 
The output after running MidptReadSeparation_v0.1.7.R gives a tsv file for each breakpoint, which indicate which case it belongs to. Using this information, the csv file from Buff_assembly_Chicago 2.R is updated with an extra two columns: decideBreak and noOfContigBreak. The column decideBreak is to flag the break as real or false. The noOfContigBreak is optional but I created it to get an idea how many times the PacBio contig is broken in HiRise.

A sample csv before and after update is Chic_1061_fragments_decideBreak.csv and Chic_1061_fragments_decideBreak2.csv in the chicago/data folder, respectively.

### Re-order PacBio contigs based on real and false breaks
Since we know have scored all breakpoints as real or false, we are now ready to re-order the PacBio contigs. The script reordering_HiRise_v0.0.2.sh will take care of this step. See folder reordering_HiRise_result/. However, it can only automate the gathering of contigs that belong to single_unbroken and joined_unbroken_only, which consist the  majority of PacBio contigs. 

For contigs that belong to the categories join_both, single_unbroken and broken_only, I dealt with them in a semi-automated way. An Excel file Chic_1061_step3a.xlsx is used to keep a counter of what scaffold to create. Each scaffold is created one by one using the Excel file as a guide and the script is generateScaffold.sh, which is dependent on a tool known as CombineFasta. 

The folder outputStep3/ contains a complete log of which scaffold is created from which contig join. The file log_for_generateScaff.log keeps a log for all decisions in contigs join to make scaffolds. Although this process is tedious, FALCON-Unzip assembler gives a manageable 953 primary contigs, most of which were unbroken.

Dependency

https://github.com/njdbickhart/CombineFasta

The scaffolding with Hi-C data by HiRise were checked in a similar way. It was much easier as only 6 HiRise breaks were introduced. Four of the breaks were false breaks.

