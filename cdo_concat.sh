
#!/bin/bash
# ------------------------------------------------------------------------------
# CDO CONCAT
# ------------------------------------------------------------------------------
#$ -cwd -V
#$ -l h_rt=48:00:00
#$ -pe smp 10
#$ -l h_vmem=8G
#$ -m be
#$ -M earhbu@leeds.ac.uk
#$ -N cdo_concat_ps

# edit var= accodingly
# Run after wget scripts
module purge
module load licenses sge intel/19.0.4
export OMP_NUM_THREADS=10
module load cdo
ens=r2i1p1
rcp=rcp85
y1=2005
y2=2100
var=ps
cd staging
# merge
cdo mergetime ${var}_*.nc ${var}_6hrLev_HadGEM2-ES_rcp85_r2i1p1_all.nc
# reset calender
cdo  setreftime,1859-12-01,0,1day -settaxis,${y1}-12-21,6:00:00,6hour -setcalendar,standard ${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_all.nc ${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_all_standard.nc
# remove the original merged file
rm -f ${var}_6hrLev_HadGEM2-ES_rcp85_r2i1p1_all.nc
# tidy up
mkdir ${var}
mv ${var}_*.nc ${var}
mv ${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_all_standard.nc .
cd ..
