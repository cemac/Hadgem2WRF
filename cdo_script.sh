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
cdo -remapbil,r192X145 ${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc ${ens}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc
cdo -remapbil,r192X145 ${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc ${ens}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}_remap.nc
cdo setcalendar,standard hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
cdo setcalendar,standard psl_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc psl_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
cdo setcalendar,standard ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
cdo setcalendar,standard ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
cdo setcalendar,standard va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
cdo setcalendar,standard ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc

cdo  setreftime,1859-12-01,0,1day -settaxis,2009-12-21,6:00:00,6hour -setcalendar,standard hus_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100.nc hus_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100_startdard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,2009-12-21,6:00:00,6hour -setcalendar,standard ps_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100.nc ps_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100_startdard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,2009-12-21,6:00:00,6hour -setcalendar,standard va_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100.nc va_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100_startdard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,2009-12-21,6:00:00,6hour -setcalendar,standard ua_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100.nc ua_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100_startdard.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,2009-12-21,6:00:00,6hour -setcalendar,standard ta_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100.nc ta_6hrLev_HadGEM2-ES_rcp45_r2i1p1_2009122106-2010122100_startdard.nc
