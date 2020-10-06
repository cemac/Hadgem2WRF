#!/bin/bash -
print_usage() {
  echo "
 call ncl script.sh
 A CEMAC script to turn the manipulated Hadgem files to WRF intermediat files
 Usage:
  .\gen_year_intermidate.sh -y 
 Options:
  -y year
  -h HELP: prints this message!
 **
 Code my be modified such as altering version dates for alternative experiments
 obtained via https://esgf-node.llnl.gov/search/cmip5/
 **
 version: 0.4 (beta un-released)
 ------------------------------------------------

  "
}

while getopts 'y:h' flag; do
  case "${flag}" in
    y) year="${OPTARG}" ;;
    h) print_usage
      exit 1 ;;
    *) print_usage
      exit 1 ;;
  esac
done
# if its just one year then set year2 as the same
if [ ! -e year2 ]; then
    year2=$year
fi


module load ncl
# add in the years either side
yearm1=$(($year-1))
yearp1=$(($year+1)) 
ncl year="${yearm1}" 'month="12"' mth=12 had2int.ncl
ncl year="${year}" 'month="01"' mth=1 had2int.ncl
ncl year="${year}" 'month="02"' mth=2 had2int.ncl
ncl year="${year}" 'month="03"' mth=3 had2int.ncl
ncl year="${year}" 'month="04"' mth=4 had2int.ncl
ncl year="${year}" 'month="05"' mth=5 had2int.ncl
ncl year="${year}" 'month="06"' mth=6 had2int.ncl
ncl year="${year}" 'month="07"' mth=7 had2int.ncl
ncl year="${year}" 'month="08"' mth=8 had2int.ncl
ncl year="${year}" 'month="09"' mth=9 had2int.ncl
ncl year="${year}" 'month="10"' mth=10 had2int.ncl
ncl year="${year}" 'month="11"' mth=11 had2int.ncl
ncl year="${year}" 'month="12"' mth=12 had2int.ncl
ncl year="${yearp1}" 'month="01"' mth=1 had2int.ncl

