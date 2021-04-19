
#!/bin/bash
# ------------------------------------------------------------------------------
# CDO SPLIT (CDO script3) 
#------------------------------------------------------------------------------
#$ -cwd -V
#$ -l h_rt=4:00:00
#$ -pe smp 10
#$ -l h_vmem=8G
#$ -M earhbu@leeds.ac.uk
#$ -N cdo_split
# edit the var variable appropriately and run after cdo_concat and cdo_var

module purge
module load licenses sge intel/19.0.4
export OMP_NUM_THREADS=10
module load cdo
ens=r2i1p1
rcp=rcp85
y1=2005
y2=2100
var=va
cdo splityear ${rcp}/${ens}/${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_all_standard.nc ${rcp}/${ens}/${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_
for y in $(seq $y1 $y2);
do
cdo splitmon ${rcp}/${ens}/${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}.nc ${rcp}/${ens}/${var}/${var}_6hrLev_HadGEM2-ES_${rcp}_${ens}_${y}_
done

