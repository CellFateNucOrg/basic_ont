#! /bin/bash

## Allocate resources
#SBATCH --time=1-00:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-2
#SBATCH --mail-user=jennifer.semple@izb.unibe.ch 
#SBATCH --mail-type=NONE 
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
# aligning to genome
################################################

echo "aligning to genome..."

mkdir -p ${bam_DIR}/

# map reads to genome with minimap2
# filter reads with flag=2308: unmapped (4) + secondary alignment (256) + supplementary alignment (2048)
minimap2 -ax map-ont $genomeFile ${bcfastq_DIR}/pass/${bc}.fastq.gz | samtools view -F 2308 -q 30 -b | samtools sort -T pass_${bc} -o ${bam_DIR}/${expName}_pass_${bc}.sorted.bam

echo "index bam file ..."
samtools index ${bam_DIR}/${expName}_pass_${bc}.sorted.bam



