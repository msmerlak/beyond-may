#!/bin/bash

#SBATCH --job-name=mu-sigma
#SBATCH --mail-user=matteo.smerlak@gmail.com --mail-type=ALL
#SBATCH --clusters=mesopsl1
#SBATCH --partition=def
#SBATCH --qos=mesopsl1_def_long
#SBATCH --account=smerlak
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16

julia --threads=auto /travail/msmerlak/general-stability/scripts/mu-sigma.jl > /travail/msmerlak/general-stability/scripts/mu-sigma.out