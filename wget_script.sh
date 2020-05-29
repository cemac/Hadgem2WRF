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
year=2010
yearm1=$((year-1))
Tframe6hr=${yearm1}122106-${year}122100
TframeALmon=200512-203011
TframeOmon=200512-210012
sixhvdate=20121017
Omonvdate=20120229
ALmonvdate=20111129
url=http://esgf-data1.ceda.ac.uk/thredds/fileServer/esg_dataroot/cmip5/output1/MOHC/HadGEM2-ES
rcp=rcp45
ens=r2i1p1
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/hus/hus_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/psl/psl_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/ps/ps_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/ta/ta_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/va/va_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/ua/ua_6hrLev_HadGEM2-ES_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/mon/land/Lmon/${ens}/v${ALmonvdate}/tsl/tsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${TframeALmon}.nc
wget ${url}/${rcp}/mon/land/Lmon/${ens}/v${ALmonvdate}/mrlsl/mrlsl_Lmon_HadGEM2-ES_${rcp}_${ens}_${TframeALmon}.nc
wget ${url}/${rcp}/mon/seaIce/OImon/${ens}/v${monvdate}/sic/sic_OImon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc
wget ${url}/${rcp}/mon/ocean/Omon/${ens}/v${monvdate}/tos/tos_Omon_HadGEM2-ES_${rcp}_${ens}_${TframeOmon}.nc
wget ${url}/${rcp}/mon/atmos/Amon/${ens}/v${ALmonvdate}/ts/ts_Amon_HadGEM2-ES_${rcp}_${ens}_${TframeALmon}.nc
wget ${url}/${rcp}/mon/atmos/Amon/${ens}/v${ALmonvdate}/zg/zg_Amon_HadGEM2-ES_${rcp}_${ens}_${TframeALmon}.nc
wget ${url}/${rcp}/mon/landIce/LImon/${ens}/v${ALmonvdate}/snw/snw_LImon_HadGEM2-ES_${rcp}_${ens}_${TframeALmon}.nc
