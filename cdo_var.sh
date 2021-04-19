
#!/bin/bash
# ------------------------------------------------------------------------------
# CDO VAR
# ------------------------------------------------------------------------------
#$ -cwd -V
#$ -l h_rt=48:00:00
#$ -pe smp 10
#$ -l h_vmem=8G

# edit var= accordingly 
# to be run as job script after cdo_concat
module purge
module load licenses sge intel/19.0.4
export OMP_NUM_THREADS=10
module load cdo
ens=r2i1p1
rcp=rcp85
y1=2005
y2=2100
var=ua # EDIT ME
cd staging
# reset calander
cdo mergetime ${var}_*.nc ${var}_6hrLev_HadGEM2-ES_rcp85_r2i1p1_all.nc
cdo  setreftime,1859-12-01,0,1day -settaxis,${y1}-12-21,6:00:00,6hour -setcalendar,standard ${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_all.nc ${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_all_standard.nc
# file
mv ${var}_6hrLev_HadGEM2-ES_${rcp}_all_standard.nc ../${rcp}/${ens}/${var}/
# Split into yearly files monthly and yearly vars
cdo splityear ../${rcp}/${ens}/${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_all_standard.nc ../${rcp}/${ens}/${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_
for y in $(seq $y1 $y2);
do
cdo splitmon ../${rcp}/${ens}/${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}.nc ../${rcp}/${ens}/${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}_
done
cd ..
