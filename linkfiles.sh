#!/bin/bash --
#title          :linkfiles.sh
#description    :linkfile
#author         :CEMAC - Helen
#date           :20210415
#version        :1
#usage          :./linkfiles.sh
#notes          : link the 1st of each following month for WRF to generate 1st month restart files 
#bash_version   :4.2.46(2)-release
#============================================================================
# example year
year1=2021
print_usage() {
  echo "
 linkfiles.sh
 A CEMAC script to link the 1st of each following month wrf intermediate files  
 for WRF to generate 1st month restart files 
 Usage:
  .\linkfile.sh -y 
 Options:
  -y year start
  -h HELP: prints this message!
 **
 **
 version: 0.4 (beta un-released)
 ------------------------------------------------

  "
}

while getopts 'y:z:r:e:h' flag; do
  case "${flag}" in
    y) year="${OPTARG}" ;;
    h) print_usage
      exit 1 ;;
    *) print_usage
      exit 1 ;;
  esac
done

cd OUTPUT
# assign the year for dec
year2=$(($year+1))
# get absolute filepath
cd $year2
filepath2=$(pwd)
# get absolute file path for wrf intermediate files
cd ../$year1
filepath=$(pwd)
# for each month link absolute file paths
cd 01
ln -sf ${filepath}/02/"Hadgemes2_r2i1p1_rcp85:"${year1}"-02-01_00" .
cd ../02
ln -sf ${filepath}/03/"Hadgemes2_r2i1p1_rcp85:"${year1}"-03-01_00" .
cd ../03
ln -sf ${filepath}/04/"Hadgemes2_r2i1p1_rcp85:"${year1}"-04-01_00" .
cd ../04
ln -sf ${filepath}/05/"Hadgemes2_r2i1p1_rcp85:"${year1}"-05-01_00" .
cd ../05
ln -sf ${filepath}/06/"Hadgemes2_r2i1p1_rcp85:"${year1}"-06-01_00" .
cd ../06
ln -sf ${filepath}/07/"Hadgemes2_r2i1p1_rcp85:"${year1}"-07-01_00" .
cd ../07
ln -sf ${filepath}/08/"Hadgemes2_r2i1p1_rcp85:"${year1}"-08-01_00" .
cd ../08
ln -sf ${filepath}/09/"Hadgemes2_r2i1p1_rcp85:"${year1}"-09-01_00" .
cd ../09
ln -sf ${filepath}/10/"Hadgemes2_r2i1p1_rcp85:"${year1}"-10-01_00" .
cd ../10
ln -sf ${filepath}/11/"Hadgemes2_r2i1p1_rcp85:"${year1}"-11-01_00" .
cd ../11
ln -sf ${filepath}/12/"Hadgemes2_r2i1p1_rcp85:"${year1}"-12-01_00" .
cd ../12
ln -sf ${filepath2}/01/"Hadgemes2_r2i1p1_rcp85:"${year2}"-01-01_00" .
cd ../../
echo "files linked"
