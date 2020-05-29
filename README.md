# Hadgem to WRF intermediate files

This work was done as part of the PEGASUS project but has wider applications for anyone wishing to run WRF from climate model output.

## Description

A pipeline to generate WRF intermediate files from Hadgemes2 output based off of NCARS cesm-to-wrf.ncl
scripts provided on the WRF user site. Hadgemes2 outputs different variables and has a different vertical
co-coordinate system therefore significant modifications are required to the ncl code to generate
the WRF intermediate files.

Hopefully this will give a good starting point for those wishing to drive WRF with output from climate
models similar to Hadgem_es2.

## Requirements

* ncl
* cdo
* bash

## Running

* All scripts can be ran induvidually however `prepare_experiment.sh` will run the
scripts in order.
* All shell scripts have help funtions and designed to be ran in order:
 * `wget_script.sh` will download hadgem files
 * `cdo_script.sh` will manipulate files by calander swapping, remapping and timeslicing
 * `file_vars.sh` will create a filesytem for the files with the option storing elsewhere and creating symlinks
 * `had2int.ncl` will create WRF intermediate files ready to be used by metgrid

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
