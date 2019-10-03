#! /bin/bash

## Allocate resources
#SBATCH --time=8-00:00:00
#SBATCH --partition=all
#SBATCH --mem-per-cpu=24G
#SBATCH --cpus-per-task=8

## job name
#SBATCH --job-name="multi2single_fast5"

source ${CONDA_ACTIVATE} BASIC_ONT
source ./varSettings.sh

multi_to_single_fast5 --input_path ${multiFast5_DIR}/ --save_path ${singleFast5_DIR}/ -t $SLURM_CPUS_PER_TASK --recursive

