<div align="center">
  <a href="https://www.cemac.leeds.ac.uk/">
  <img src="https://github.com/cemac/cemac_generic/blob/master/Images/cemac.png"></a>
  <br>
</div>

 <h1> <center>Hadgem to WRF intermediate files </center> </h1>

 ![GitHub release](https://img.shields.io/github/release/cemac/Hadgem2WRF.svg) ![GitHub](https://img.shields.io/github/license/cemac/Hadgem2WRF.svg) [![GitHub top language](https://img.shields.io/github/languages/top/cemac/Hadgem2WRF.svg)](https://github.com/cemac/Hadgem2WRF) [![GitHub issues](https://img.shields.io/github/issues/cemac/Hadgem2WRF.svg)](https://github.com/cemac/Hadgem2WRF/issues) [![GitHub last commit](https://img.shields.io/github/last-commit/cemac/Hadgem2WRF.svg)](https://github.com/cemac/Hadgem2WRF/commits/master) [![GitHub All Releases](https://img.shields.io/github/downloads/cemac/Hadgem2WRF/total.svg)](https://github.com/cemac/Hadgem2WRF/releases)

 [![HitCount](http://hits.dwyl.com/{cemac}/{Hadgem2WRF}.svg)](http://hits.dwyl.com/{cemac}/{Hadgem2WRF})

This work was done as part of the PEGASUS project but has wider applications for anyone wishing to run WRF from climate model output.

## Description

A pipeline to generate WRF intermediate files from Hadgemes2 output based off of NCARS cesm-to-wrf.ncl
scripts provided on the WRF user site. Hadgemes2 outputs different variables and has a different vertical
co-coordinate system therefore significant modifications are required to the ncl code to generate
the WRF intermediate files.

Hopefully this will give a good starting point for those wishing to drive WRF with output from climate
models similar to Hadgem_es2.

This pipeline fetches data from [https://esgf-node.llnl.gov/projects/cmip5/](https://esgf-node.llnl.gov/projects/cmip5/).

## Requirements

* ncl
* cdo
* bash

## Running

### per year intermediates 
* All scripts can be ran induvidually however `Hadgem2WRF.sh` will run the
scripts in order.
* All shell scripts have help funtions and designed to be ran in order:
 * `wget_script.sh` will download hadgem files
 * `cdo_script.sh` will manipulate files by calander swapping, remapping and timeslicing
 * `file_vars.sh` will create a filesytem for the files with the option storing elsewhere and creating symlinks
 * `had2int.ncl` will create WRF intermediate files ready to be used by metgrid

### whole 100 year generation

A seperate set of job scripts (SGE / PBS *(minor modifications)* ) have been written in 
the run all folder. wget all scripts can be retrieved from. [https://esgf-node.llnl.gov/projects/cmip5/](https://esgf-node.llnl.gov/projects/cmip5/)

* `mv run_all/* .`
* `# wget all var files into the staging area`
* `# This creates a huge TBS amount of data, so recommended 1 var at a time`
* `# Each script has a "var = " line adjust accordingly for each 6 day var'
* `# monthly vars can be retrieved via the normal method as this is done in 1 to 3 chunks only depending on variable'
1. `qsub cdo_concat.sh`
2. `qsub cdo_var.sh`
3. `qsub cdo_split.sh`
4. `#REPEAT for each var`
5. `qsub ncl_all.sh #edit for years to loop over depending on your job schedular time limits`
6. `./linkfiles.sh' # will symlink 1st of each month in order for wrf to creating 1st month restart filesif running monthly sims` 

## Contribution guidelines

Contributions are welcome small or large if you would like to contribute e.g.
fix spelling, submit code for other climate models or  translate the ncl code
into python please have a look a the contribution guidelines and submit a pull
request.

## Aknowledgements

* These scripts are based off of [NCAR's cesm-to-wrf.ncl]() scripts
* Equations used in the main ncl code are cited in situ

<hr>

## Future

* ncl is being phased out, a phython version of this would be desired but is not under
current development
