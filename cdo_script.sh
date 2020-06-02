#!/bin/bash -
#title          :splitnetcdf.sh
#description    :split year files to monthly
#author         :CEMAC - Helen
#date           :20200226
#version        :0.1
#usage          :./splitnetcdf.sh
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
if [ -e  mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ]; then
    mv mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/mrlsl/
    mv snw_LImon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/snw/
    mv ts_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/ts/
    mv tsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/tsl/
    mv zg_Amon_HadGEM2-ES_${rcp}_${ens}_${tframmon}.nc ${rcp}/${ens}/zg/
fi
# Ocean files and grid files downloaded only once
if [ -e sic_OImon_HadGEM2-ES_${rcp}_${ens}_200512-210012.nc ]; then
    mv sic_OImon_HadGEM2-ES_${rcp}_${ens}_200512-210012.nc ${rcp}/${ens}/sic/
    mv tos_Omon_HadGEM2-ES_${rcp}_${ens}_200512-210012.nc ${rcp}/${ens}/tos/
    #mv areacello_fx_HadGEM2-ES_${rcp}_r0i0p0.nc ${rcp}/${ens}/
    # remap ocean files
    cdo -remapbil,r192X145 ${rcp}/${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc ${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc
