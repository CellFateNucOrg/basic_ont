#! /bin/bash

# name of experiment
expName=Intestine_Muscle_

# gets the directory name one level above where the script is
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd ../ && pwd )"

# default directory names. Can be changed, but keep consistent within an analysis
multiFast5_DIR=${WORK_DIR}/fast5
fastq_DIR=${WORK_DIR}/fastq	
qc_DIR=${WORK_DIR}/qc
bcfastq_DIR=${WORK_DIR}/bcfastq
bam_DIR=${WORK_DIR}/bam

# location of genome file for alignment
genomeFile=/mnt/imaging.data/pmeister/ce11/genome.fa

# list of barcodes that were used in this run
barcodesUsed=( barcode01 barcode02 barcode03 barcode04 barcode05 barcode06 barcode07 barcode08 barcode09 barcode10 barcode11 barcode12 )
