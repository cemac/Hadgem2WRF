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
year=2013
yearm1=$((year-1))
tframe=${yearm1}122106-${year}122100
tframmon=200512-203011
if [ ! -e ${rcp}/${ens} ]; then
    mkdir -p ${rcp}/${ens}
fi
# reset calander
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100.nc hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y
earm1}122106-${year}122100_standard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100.nc ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yea
rm1}122106-${year}122100_standard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100.nc va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yea
rm1}122106-${year}122100_standard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100.nc ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yea
rm1}122106-${year}122100_standard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${yearm1}-12-21,6:00:00,6hour -setcalendar,standard ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100.nc ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yea
rm1}122106-${year}122100_standard.nc
# file
mv ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100_standard.nc ${rcp}/${ens}/ta/
mv ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100_standard.nc ${rcp}/${ens}/ua/
mv va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100_standard.nc ${rcp}/${ens}/va/
mv ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100_standard.nc ${rcp}/${ens}/ps/
mv hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}122106-${year}122100_standard.nc ${rcp}/${ens}/hus/
# Monthly files only downloaded every 30 years
if [ -e  ${rcp}/${ens}/${tframmon}_complete.txt ]; then
    mv mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/mrlsl/
    mv snw_LImon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/snw/
    mv ts_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/ts/
    mv tsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/tsl/
    mv zg_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/zg/
    cdo splityear ${rcp}/${ens}/mrlsl/mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/mrlsl/mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ${rcp}/${ens}/snw/snw_LImon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/snw/snw_LImon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ${rcp}/${ens}/ts/ts_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/ts/ts_Amon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ${rcp}/${ens}/tsl/tsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/tsl/tsl_Lmon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ${rcp}/${ens}/zg/zg_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/zg/zg_Amon_HadGEM2-ES_${rcp}_${ens}_
    touch ${rcp}/${ens}/${tframmon}_complete.txt
fi
# Ocean files and grid files downloaded only once
if [ -e ${rcp}/${ens}/sic/ocean_complete.txt ]; then
    mv sic_OImon_HadGEM2-ES_${rcp}_${ens}_200512-210012.nc ${rcp}/${ens}/sic/
    mv tos_Omon_HadGEM2-ES_${rcp}_${ens}_200512-210012.nc ${rcp}/${ens}/tos/
    # remap ocean files
    echo "remapping and splitting ocean files into years"
    cdo -remapbil,r192X145 ${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc ${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc
    cdo -remapbil,r192X145 ${rcp}/${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc ${rcp}/${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc
    cdo splityear ${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc ${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_
    cdo splityear ${rcp}/${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc ${rcp}/${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_
    touch ${rcp}/${ens}/sic/ocean_complete.txt
fi
# Split into yearly files monthly and yearly vars
if [ -e ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}]; then
  echo "deleting old year split"
  rm -f ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}
  rm -f ${rcp}/${ens}/ua/us_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}
  rm -f ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}
  rm -f ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}
  rm -f ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}
fi
cdo splityear ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${tframe}_standard.nc ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_
cdo splityear ${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${tframe}_standard.nc ${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_
cdo splityear ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${tframe}_standard.nc ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_
cdo splityear ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${tframe}_standard.nc ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_
cdo splityear ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${tframe}_standard.nc ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_
if [ -e ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${yearm1}_12.nc ]; then
  echo "Found dec from previous year, merging ...."
  cdo splitmon ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/va/va_${yearm1}_temp_
  cdo splitmon ${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/ua/ua_${yearm1}_temp_
  cdo splitmon ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/ps/ps_${yearm1}_temp_
  cdo splitmon ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/ta/ta_${yearm1}_temp_
  cdo splitmon ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/hus/hus_${yearm1}_temp_
  cdo mergetime ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/va/va_${yearm1}_temp_12.nc ${rcp}/${ens}/va/va_${yearm1}_temp.nc
  cdo mergetime ${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/ua/ua_${yearm1}_temp_12.nc ${rcp}/${ens}/ua/ua_${yearm1}_temp.nc
  cdo mergetime ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/ta/ta_${yearm1}_temp_12.nc ${rcp}/${ens}/ta/ta_${yearm1}_temp.nc
  cdo mergetime ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/ps/ps_${yearm1}_temp_12.nc ${rcp}/${ens}/ps/ps_${yearm1}_temp.nc
  cdo mergetime ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/hus/hus_${yearm1}_temp_12.nc ${rcp}/${ens}/hus/hus_${yearm1}_temp.nc
  rm -f ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/va/va_${yearm1}_temp_12.nc
  mv ${rcp}/${ens}/va/va_${yearm1}_temp.nc ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc
  rm -f ${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/ua/ua_${yearm1}_temp_12.nc
  mv ${rcp}/${ens}/ua/ua_${yearm1}_temp.nc ${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc
  rm -f ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/ta/ta_${yearm1}_temp_12.nc
  mv ${rcp}/${ens}/ta/ta_${yearm1}_temp.nc ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc
  rm -f ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/ps/ps_${yearm1}_temp_12.nc
  mv ${rcp}/${ens}/ps/ps_${yearm1}_temp.nc ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc
  rm -f ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc ${rcp}/${ens}/hus/hus_${yearm1}_temp_12.nc
  mv ${rcp}/${ens}/hus/hus_${yearm1}_temp.nc ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_12.nc
fi
# Split into monthly files 6 hourly files
cdo splitmon ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_
cdo splitmon ${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_
cdo splitmon ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_
cdo splitmon ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_
cdo splitmon ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}.nc ${rcp}/${ens}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${year}_
