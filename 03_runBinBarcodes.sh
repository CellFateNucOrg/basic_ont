#! /bin/bash

## Allocate resources
#SBATCH --time=5-00:00:00
#SBATCH --partition=all
#SBATCH --gres=gpu:1
#SBATCH --mem=96G
#SBATCH --ntasks=24


## job name
#SBATCH --job-name="binbarcodes"

source ./varSettings.sh
source ${CONDA_ACTIVATE} BASIC_ONT

echo ${singleFast5_DIR}" is my single_fast5 folder"
echo ${fastq_DIR}" is my fastq folder"
echo ${bcFastq_DIR}" is my bcFastq folder"

##################
# classify reads by barcode
##################
echo "Using Deepbinner from:"
which deepbinner
classifications=${WORK_DIR}/classifications
echo $SLURM_NTASKS_PER_NODE
#deepbinner classify --omp_num_threads ${SLURM_NTASKS} --intra_op_parallelism_threads ${SLURM_NTASKS} --inter_op_parallelism_threads 4  --native ${singleFast5_DIR} >  ${classifications}

##################
# bin by barcode
##################
cat ${fastq_DIR}/pass/* > ${fastq_DIR}/pass/passed.fastq.gz
mkdir -p ${bcFastq_DIR}/pass
deepbinner bin --classes ${classifications} --reads ${fastq_DIR}/pass/passed.fastq.gz --out_dir ${bcFastq_DIR}/pass
rm ${fastq_DIR}/pass/passed.fastq.gz

