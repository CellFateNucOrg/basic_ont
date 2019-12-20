#! /bin/bash

## Allocate resources
#SBATCH --time=2-00:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-5
#SBATCH --mail-user=peter.meister@izb.unibe.ch 
#SBATCH --mail-type=end,fail 
## you should submit as many jobs as there are barcodes in barcodesUsed
## (don't forget to include unclassfied in barcodesOfInterst in the varSettings.sh file)

## job name
#SBATCH --job-name="npAlign"

# read in the run specific settings
source ./varSettings.sh

source ${CONDA_ACTIVATE} BASIC_ONT

let i=$SLURM_ARRAY_TASK_ID-1

# take one barcode accessed using that array task number for better parallelisation
bc=${barcodesUsed[$i]} # barcode


################################################
# filtering DamID reads
################################################

echo "filtering DamID reads..."

mkdir -p ${_DIR}/

Rscript DamID_filtering.R ${work_DIR} ${bamFile}


