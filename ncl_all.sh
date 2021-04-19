#!/bin/bash
# ------------------------------------------------------------------------------
# WRFOTRON
# ------------------------------------------------------------------------------
#$ -cwd -V
#$ -l h_rt=8:00:00
#$ -pe smp 8
#$ -l h_vmem=4G
#$ -M earhbu@leeds.ac.uk
#$ -N ncl_2008

module purge
module load licenses sge intel/19.0.4
export OMP_NUM_THREADS=10
module load ncl
# loop over all 100 years
y1=2006
y2=2006
for y in $(seq $y1 $y2);
do

ncl year="${y}" 'month="01"' mth=1 had2int.ncl 
ncl year="${y}" 'month="02"' mth=2 had2int.ncl 
ncl year="${y}" 'month="03"' mth=3 had2int.ncl 
ncl year="${y}" 'month="04"' mth=4 had2int.ncl 
ncl year="${y}" 'month="05"' mth=5 had2int.ncl 
ncl year="${y}" 'month="06"' mth=6 had2int.ncl 
ncl year="${y}" 'month="07"' mth=7 had2int.ncl 
ncl year="${y}" 'month="08"' mth=8 had2int.ncl 
ncl year="${y}" 'month="09"' mth=9 had2int.ncl 
ncl year="${y}" 'month="10"' mth=10 had2int.ncl 
ncl year="${y}" 'month="11"' mth=11 had2int.ncl 
ncl year="${y}" 'month="12"' mth=12 had2int.ncl 

done
