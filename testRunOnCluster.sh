#!/bin/sh
#SBATCH -t 01:00:00
#SBATCH -N 1
#SBATCH --tasks-per-node=20
#SBATCH --exclusive
#SBATCH --qos=test
#SBATCH --mail-user=martingerdin@gmail.com
#SBATCH --mail-type=END

module load GCC/7.3.0-2.30 OpenMPI/3.1.1 R/3.5.1

mpirun --bind-to core R --slave -f MainCodeRun.R
