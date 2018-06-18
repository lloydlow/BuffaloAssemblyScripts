# Buffalo Assembly Scripts
Custom scripts to analyse scaffolds and validate genome assembly of the water buffalo.

## Table of contents
All scripts are given in the scripts directory. Specific scripts and sample datasets for the various assembly stages are given in directories listed in this repository
* scaffolding_HiRise

Here is a brief description of the contents of each directory.

### scaffolding_HiRise
This folder contains a walkthrough of how custom scripts were applied to circumvent the issues of false breaks introduced by HiRise scaffolding. The general idea is to first categorise the break status of PacBio contigs according to the HiRise scaffold program, then check PacBio coverage surrounding each breakpoint to determine whether it is likely a real or false break. Having determined the status of each breakpoint, the contigs can then be re-ordered to create better scaffolds as false breaks have been removed.


