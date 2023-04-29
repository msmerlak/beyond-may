#!/bin/sh
#SBATCH --job-name=phase-diagram
#SBATCH --time=2-00:00:00  
#SBATCH --mail-user=matteo.smerlak@gmail.com --mail-type=ALL
#SBATCH --clusters=mesopsl1
#SBATCH --partition=def
#SBATCH --qos=mesopsl1_def_long
#SBATCH --account=msmerlak
#SBATCH --nodes=12 
#SBATCH --ntasks-per-node=16

module load ma_liste_de_modules

RUNDIR=/travail/msmerlak/job.${SLURM_JOB_ID}
mkdir -p ${RUNDIR}
cd ${RUNDIR}

mpirun -np ${SLURM_NTASKS} /travail/msmerlak/general-stability/scripts/test-slurm.jl

exit 0