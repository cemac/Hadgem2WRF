#!/bin/bash -
#title          :wget_script.sh
#description    :get hadgem vars
#author         :CEMAC - Helen
#date           :20200228
#version        :0.4
#usage          :./wget_script.sh
#notes          :
#bash_version   :4.2.46(2)-release
#============================================================================
#============================================================================
# default vars
rcp=rcp85
ens=r2i1p1
year=2013
# Constant
if [ $rcp == rcp45 ]; then
  sixhvdate=20121017
  Omonvdate=20120229
  ALmonvdate=20111129
  lmskvdate=20120215
elif [ $rcp == rcp85 ]; then
  sixhvdate=20121019
  Omonvdate=20111129
  ALmonvdate=20120114
  lmskvdate=20120215
else
  echo "please look up version dates and place them in code here"
  #sixhvdate=
  #Omonvdate=
  #ALmonvdate=
fi
# Constant for HadGEM2-ES runs
TframeOmon=200512-210012
model=HadGEM2-ES
url=http://esgf-data1.ceda.ac.uk/thredds/fileServer/esg_dataroot/cmip5/output1/MOHC/${model}
print_usage() {
  echo "
 wget_script.sh
 A CEMAC script to download required variables for running WRF from Hadgem
 Usage:
  .\ wget_script.sh -y -r -e
 No options runs a default production configuration:
 Today, Viz off, 48 hours.
 Options:
  -y year
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

while getopts 'y:r:e:h' flag; do
  case "${flag}" in
    y) year="${OPTARG}" ;;
    r) rsp="${OPTARG}" ;;
    e) ens="${OPTARG}" ;;
    h) print_usage
      exit 1 ;;
    *) print_usage
      exit 1 ;;
  esac
done
# -----------------------------------------------------------------------------
# Calculate vars
# calculate Tframe fro 6 hour files
yearm1=$((year-1))
Tframe6hr=${yearm1}122106-${year}122100
# Calculate
if (($year >= 2006 && $year <= 2030)); then
  TframeALmon=200512-203011
elif (($year >= 2031 && $year <= 2055)); then
  TframeALmon=203012-205511
elif (($year >= 2056 && $year <= 2080)); then
  TframeALmon=205512-208011
elif (($year >= 2056 && $year <= 2105)); then
  TframeALmon=208012-210511
fi
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/hus/hus_6hrLev_${model}_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/psl/psl_6hrLev_${model}_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/ps/ps_6hrLev_${model}_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/ta/ta_6hrLev_${model}_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/va/va_6hrLev_${model}_${rcp}_${ens}_${Tframe6hr}.nc
wget ${url}/${rcp}/6hr/atmos/6hrLev/${ens}/v${sixhvdate}/ua/ua_6hrLev_${model}_${rcp}_${ens}_${Tframe6hr}.nc
# monthly files only need to be downloaded every 30 years
if [ ! -e tsl_Lmon_${model}_${rcp}_${ens}_${TframeALmon}.nc ]; then
    wget ${url}/${rcp}/mon/land/Lmon/${ens}/v${ALmonvdate}/tsl/tsl_Lmon_${model}_${rcp}_${ens}_${TframeALmon}.nc
    wget ${url}/${rcp}/mon/land/Lmon/${ens}/v${ALmonvdate}/mrlsl/mrlsl_Lmon_${model}_${rcp}_${ens}_${TframeALmon}.nc
    wget ${url}/${rcp}/mon/atmos/Amon/${ens}/v${ALmonvdate}/ts/ts_Amon_${model}_${rcp}_${ens}_${TframeALmon}.nc
    wget ${url}/${rcp}/mon/atmos/Amon/${ens}/v${ALmonvdate}/zg/zg_Amon_${model}_${rcp}_${ens}_${TframeALmon}.nc
    wget ${url}/${rcp}/mon/landIce/LImon/${ens}/v${ALmonvdate}/snw/snw_LImon_${model}_${rcp}_${ens}_${TframeALmon}.nc
fi
# ocean files cover whole period
if [ ! -e sic_OImon_${model}_${rcp}_${ens}_${TframeOmon}.nc ]; then
    wget ${url}/${rcp}/mon/seaIce/OImon/${ens}/v${Omonvdate}/sic/sic_OImon_${model}_${rcp}_${ens}_${TframeOmon}.nc
    wget ${url}/${rcp}/mon/ocean/Omon/${ens}/v${Omonvdate}/tos/tos_Omon_${model}_${rcp}_${ens}_${TframeOmon}.nc
fi
if [ ! -e sftlf_fx_${model}_${rcp}_${ens}_r0i0p0.nc ]; then
  if [ ! -e ${rcp}/${ens}/sftlf_fx_${model}_${rcp}_${ens}_r0i0p0.nc ]; then
    wget ${url}/${rcp}/fx/atmos/fx/r0i0p0/v${lmskvdate}/areacella/areacella_fx_${model}_${rcp}_r0i0p0.nc
  fi
fi
