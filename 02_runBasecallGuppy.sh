#! /bin/bash

## Allocate resources
#SBATCH --time=3-00:00:00
#SBATCH --partition=all
#SBATCH --gres=gpu:1

## job name
#SBATCH --job-name="guppy&qc"

./basecallGuppy.sh
