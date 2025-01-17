#! /bin/bash

## Allocate resources
#SBATCH --time=3-00:00:00
#SBATCH --partition=all
#SBATCH --gres=gpu:1
#SBATCH --mem=24G
## job name
#SBATCH --job-name="guppy&qc"
#SBATCH --mail-user=peter.meister@izb.unibe.ch
#SBATCH --mail-type=end,fail

## Script to basecall all fast5 in the folder one level up called singleFast5_DIR (named in varSettings.sh) 
## and its recursive directories with Guppy
## MUST enter the correct settings in varSettings.sh file
## (copy varSettings_example.sh to varSettings.sh and then edit it)
## .bashrc should include location of bin directory inside Guppy directory and export it as ${GUPPY_DIR}
## .bashrc should include location of conda activate script and export it s ${CONDA_ACTIVATE}
## outputs 200,000 reads per fastq file
## output will be in: ./fastqFiles/pass/
## pycoQC is run and results are in ./qc/

source ./varSettings.sh
echo "working directory is: "${WORK_DIR}
source ${CONDA_ACTIVATE} BASIC_ONT

mkdir -p ${fastq_DIR}/
${GUPPY_DIR}/guppy_basecaller --input_path ${multiFast5_DIR} --save_path ${fastq_DIR} -c ${GUPPY_DIR}/../data/dna_r9.4.1_450bps_hac.cfg --records_per_fastq 200000 --compress_fastq --recursive --qscore_filtering --min_qscore 3 --device auto
#--num_callers


##################
# run pycoQC
#################


# create qc -output directory
mkdir -p $qc_DIR

#https://github.com/a-slide/pycoQC
pycoQC -f ${fastq_DIR}/sequencing_summary.txt -o ${qc_DIR}/pycoQC_${expName}_pass.html --report_title "${expName} passed reads" --min_pass_qual 3

conda deactivate

