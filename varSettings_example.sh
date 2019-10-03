#! /bin/bash

# name of experiment
expName=Intestine_DamID

# gets the directory name one level above where the script is
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && cd ../ && pwd )"

# default directory names. Can be changed, but keep consistent within an analysis
multiFast5_DIR=${WORK_DIR}/multi_fast5
singleFast5_DIR=${WORK_DIR}/single_fast5
fastq_DIR=${WORK_DIR}/fastq
bcfastq_DIR=${WORK_DIR}/bcfastq

