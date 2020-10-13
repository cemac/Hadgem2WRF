#!/bin/bash -
#title          :cdo.sh
#description    :prep hadgem files for ncl script
#author         :CEMAC - Helen
#date           :20200226
#version        :0.2
#usage          :./cdo_script.sh
#notes          :
#bash_version   :4.2.46(2)-release
#============================================================================
module load cdo
ens=r2i1p1
rcp=rcp85
year=2030
print_usage() {
  echo "
 Hadgem2WRF.sh
 A CEMAC script to download, prepare the required variables a for running WRF 
 from Hadgem generating OUTPUT
 Usage:
  .\cdo_script.sh -y z -r -c
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
if [ ! -e year2 ]; then
    year2=$(($year+1))
fi
# Create other variables from given options
yearm1=$((year-1))
tframe=${yearm1}122106-${year}122100
if [ $year < 2030 ]; then
    tframmon=200512-203011
elif (( $year > 2030 & $year <= 2055 )); then
    tframmon=203012-205511
elif (( $year > 2055 & $year <= 2080)); then
    tframmon=205512-208011
elif (( $year > 2080 & $year <= 2100 )); then
    tframmon=208012-210011
elif [ $year == 2100 ]; then
    tframmon=210012-210012
fi
TframeOmon=200512-210012
if [ ! -e ${rcp}/${ens} ]; then
    mkdir -p ${rcp}/${ens}
    cd ${rcp}/${ens}
    mkdir ta va ua hus ps mrlsl snw tsl sic tos zg ts lmask
    cd ../..
fi
cd staging
# reset calander
cdo mergetime ua_*.nc ua_6hrLev_HadGEM2-ES_rcp85_r2i1p1_${year}-${year2}.nc
cdo mergetime va_*.nc va_6hrLev_HadGEM2-ES_rcp85_r2i1p1_${year}-${year2}.nc
cdo mergetime ta_*.nc ta_6hrLev_HadGEM2-ES_rcp85_r2i1p1_${year}-${year2}.nc
cdo mergetime hus_*.nc hus_6hrLev_HadGEM2-ES_rcp85_r2i1p1_${year}-${year2}.nc
cdo mergetime ps_*.nc ps_6hrLev_HadGEM2-ES_rcp85_r2i1p1_${year}-${year2}.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}.nc hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}.nc ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}.nc va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}.nc ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}.nc ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc
# file
mv ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/ta/
mv ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/ua/
mv va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/va/
mv ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/ps/
mv hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/hus/
# Monthly files only downloaded every 30 years
if [ ! -e  ../${rcp}/${ens}/${tframmon}_complete.txt ]; then
    mv mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/mrlsl/
    mv snw_LImon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/snw/
    mv ts_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/ts/
    mv tsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/tsl/
    mv zg_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/zg/
    cdo splityear ../${rcp}/${ens}/mrlsl/mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/mrlsl/mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ../${rcp}/${ens}/snw/snw_LImon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/snw/snw_LImon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ../${rcp}/${ens}/ts/ts_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/ts/ts_Amon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ../${rcp}/${ens}/tsl/tsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/tsl/tsl_Lmon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ../${rcp}/${ens}/zg/zg_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ../${rcp}/${ens}/zg/zg_Amon_HadGEM2-ES_${rcp}_${ens}_
    touch ../${rcp}/${ens}/${tframmon}_complete.txt
fi
# Ocean files and grid files downloaded only once
if [ ! -e ../${rcp}/${ens}/sic/ocean_complete.txt ]; then
    mv sic_OImon_HadGEM2-ES_${rcp}_${ens}_200512-210012.nc ../${rcp}/${ens}/sic/
    mv tos_Omon_HadGEM2-ES_${rcp}_${ens}_200512-210012.nc ../${rcp}/${ens}/tos/
    # remap ocean files
    echo "remapping and splitting ocean files into years"
    cdo -remapbil,r192X145 ../${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc ../${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc
    cdo -remapbil,r192X145 ../${rcp}/${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc ../${rcp}/${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc
    cdo splityear ../${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc ../${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ../${rcp}/${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc ../${rcp}/${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_
    touch ../${rcp}/${ens}/sic/ocean_complete.txt
fi
# Split into yearly files monthly and yearly vars
cdo splityear ../${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_
cdo splityear ../${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_
cdo splityear ../${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_
cdo splityear ../${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_
cdo splityear ../${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}-${year2}_standard.nc ../${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_
for y in $(seq $yearm1 $year2);
do
  # Split into monthly files 6 hourly files
  cdo splitmon ../${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}.nc ../${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}_
  cdo splitmon ../${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}.nc ../${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}_
  cdo splitmon ../${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}.nc ../${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}_
  cdo splitmon ../${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}.nc ../${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}_
  cdo splitmon ../${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}.nc ../${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}_
done
cd ..
rm -f staging/*
