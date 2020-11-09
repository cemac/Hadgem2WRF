#!/bin/bash -
#title          :getvars.sh
#description    :get hadgem vars
#author         :CEMAC - Helen
#date           :20200228
#version        :0.2
#usage          :./getvars.sh
#notes          :
#bash_version   :4.2.46(2)-release
#============================================================================
print_usage() {
  echo "
 Hadgem2WRF.sh
 A CEMAC script to download, prepare the required variables a for running WRF 
 from Hadgem generating OUTPUT
 Usage:
  .\run_all.sh -y z -r -c
 Options:
  -y1 year
  -z year (end date if range)
  -r rcp
  -e ensemble member (r2i1p1)
  -h HELP: prints this message!
 **
 Code my be modified such as altering version dates for alternative experiments
 obtained via https://esgf-node.llnl.gov/search/cmip5/
 **
 version: 0.4 (beta un-released)
 ------------------------------------------------

  "
}

while getopts 'y:z:r:e:h' flag; do
  case "${flag}" in
    y) year="${OPTARG}" ;;
    z) year2="${OPTARG}" ;; 
    r) rsp="${OPTARG}" ;;
    e) ens="${OPTARG}" ;;
    h) print_usage
      exit 1 ;;
    *) print_usage
      exit 1 ;;
  esac
done
# if its just one year then set year2 as the same
if [ ! -e $year2 ]; then
    year2=$year
fi
# to capture dec the year before and the jan 1st day of year end
# get data from the year before and after range
for yy in $(seq $(($year-1)) $(($year2+1)));
do
   ./wget_script.sh -y $yy
done
# If one year just run cdo for that year
if [ $year2==$year ]; then
    ./cdo_script.sh -y $year 
else
    ./cdo_script.sh -y $year -z $year2
fi

# Run ncl script
# NCL runs from dec year minus 1 to jan year plus 1
for yy in $(seq $(($year)) $(($year2)));
do
    ./ncl_year.sh -y $yy 
done
