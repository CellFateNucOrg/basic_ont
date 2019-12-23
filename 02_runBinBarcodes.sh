#! /bin/bash

## Allocate resources
#SBATCH --time=3-00:00:00
#SBATCH --partition=all
#SBATCH --gres=gpu:1
#SBATCH --mem=96G
#SBATCH --ntasks=24
##SBATCH --mem-per-cpu=16G
##SBATCH --cpus-per-task=4
#SBATCH --mail-user=peter.meister@izb.unibe.ch
#SBATCH --mail-type=end,fail

## job name
#SBATCH --job-name="binbarcodes"

source ./varSettings.sh
source ${CONDA_ACTIVATE} BASIC_ONT

echo ${singleFast5_DIR}" is my single_fast5 folder"
echo ${fastq_DIR}" is my fastq folder"
echo ${bcfastq_DIR}" is my bcFastq folder"

##################
# classify reads by barcode
##################
echo "Using guppy-barcoder"
echo $SLURM_NTASKS
mkdir -p ${bcfastq_DIR}
${GUPPY_DIR}/guppy_barcoder -i ${fastq_DIR} -s ${bcfastq_DIR} --recursive -t $SLURM_NTASKS -q 40000 --compress_fastq -x auto --barcode_kits "EXP-NBD104"



