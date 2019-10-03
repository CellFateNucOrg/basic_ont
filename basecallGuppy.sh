#! /bin/bash
## script to basecall all fast5 in the folder one level up called fast5files and its recursive directories with Guppy
## .bashrc should include location of bin directory inside Guppy directory and export it as ${GUPPY_DIR}
## uses barcoding
## outputs 200,000 reads per fastq file (-q option)
## output will be in e.g: ./fastqFiles/pass/
## pycoQC is run and results are in ./qc/

source ./varSettings.sh
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "working directory is: "${WORK_DIR}
source ${CONDA_ACTIVATE} BASIC_ONT

mkdir -p ${WORK_DIR}/fastqFiles
${GUPPY_DIR}/guppy_basecaller --input_path ${singleFast5_DIR} --save_path ${WORK_DIR}/fastqFiles -c ${GUPPY_DIR}/../data/dna_r9.4.1_450bps_hac.cfg --records_per_fastq 200000 --compress_fastq --recursive --qscore_filtering --min_qscore 3 --device auto
#--num_callers


##################
# run pycoQC
#################


# create qc output directory
qcDir=./qc
mkdir -p $qcDir

#https://github.com/a-slide/pycoQC
pycoQC -f ${WORK_DIR}/fastqFiles/sequencing_summary.txt -o ${qcDir}/pycoQC_${expName}_pass.html --title ""${expName}" passed reads" --min_pass_qual 3

conda deactivate
