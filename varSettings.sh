#! /bin/bash

# name of experiment
expName=XXX_DamID

# gets the directory name one level above where the script is
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd ../ && pwd )"

# default directory names. Can be changed, but keep consistent within an analysis
multiFast5_DIR=${WORK_DIR}/multi_fast5
singleFast5_DIR=${WORK_DIR}/single_fast5
fastq_DIR=${WORK_DIR}/fastq	
qc_DIR=${WORK_DIR}/qc
bcfastq_DIR=${WORK_DIR}/bcfastq
bam_DIR=${WORK_DIR}/bam

# location of genome file for alignment
genomeFile=/mnt/imaging.data/pmeister/ce11/genome.fa

# list of barcodes that were used in this run
barcodesUsed=( barcode01 barcode03 barcode05 barcode07 barcode08 barcode10 )
