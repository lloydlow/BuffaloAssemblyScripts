# Buffalo Assembly Scripts
Custom scripts to analyse scaffolds and validate genome assembly of the water buffalo.

## Table of contents
All scripts are given in the scripts directory. Specific scripts and sample datasets for the various assembly stages are given in directories listed in this repository
* scaffolding_HiRise
* checks_of_scaffold_joins
 
Here is a brief description of the contents of each directory.

### scaffolding_HiRise
This folder contains a walkthrough of how custom scripts were applied to circumvent the issues of false breaks introduced by HiRise scaffolding. The general idea is to first categorise the break status of PacBio contigs according to the HiRise scaffold program, then check PacBio coverage surrounding each breakpoint to determine whether it is likely a real or false break. Having determined the status of each breakpoint, the contigs can then be re-ordered to create better scaffolds as false breaks have been removed.

### checks_of_scaffold_joins
This folder contains information on how linkage disequilibrium (LD) data was used together with conservation of synteny with cattle and goat genomes to validate the assembly, order and orientation of contigs in scaffolds. It details an R script used to help score LD jump and out of synteny gaps in the assembly to flag potential mis-joins. A record of all reordering of scaffolds is also given.

