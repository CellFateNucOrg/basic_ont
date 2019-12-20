###Pipeline
#1. Demultiplexing with Deepbinner realtime
#2. Basecalling with guppy-cpu
#3. QC with pycoQC -i input_summary_name -b barcode_summary_name -o output_file_name
#4. mapping with minimap2 -ax map-ont ../../../ce11/genome.fa ./*.fastq > bc3barcode10.sam
#5. sorting of sam files samtools sort bc3barcode09.sam > bc3barcode09_sorted.sam
#6. conversion of the sam files to bam files samtools view -b -q 30 bc3barcode09_sorted.sam > bc3barcode09_sorted_q30.bam
#7. indexing of the bam file samtools index bc3barcode09_sorted_q30.bam

###############################################################################
# The function expects a sorted bam file as an input (as the name of the file)
# it outputs 1. the same bam file minus the non-damid reads 
#            2. the coverage file corresponding to the damid reads as a bigwig
###############################################################################


library(Biostrings)
library(GenomicRanges)
library(BSgenome.Celegans.UCSC.ce11)
library(Rsamtools)
library(GenomicAlignments)
library(rtracklayer)
genome = Celegans
re.site= "GATC"

########################################################################
all.GATC <- vmatchPattern(re.site, genome)
all.GATC <- all.GATC[strand(all.GATC)=="+"]
strand(all.GATC)="*"
# This bit is to make a simple GATC track to display GATC localization 
#all.GATC$score <- rep(1,length(all.GATC))
#export.wig(all.GATC, "GATC_track.bw")#
########################################################################

#GAlfile = "XXX_DamID_pass_barcode01.sorted.bam"
damid_filtering <- function(GAlfile)
  {GAl <- readGAlignments(GAlfile, use.names=TRUE)
  GAl.gr <- granges(GAl)
  cvg_original <- coverage(GAl.gr)
  export.bw(cvg_original,paste0(gsub(".bam","_coverage.bw",GAlfile)))
  GAl.gr_ext <- GAl.gr
  start(GAl.gr_ext)<- start(GAl.gr)-8
  end(GAl.gr_ext)<- end(GAl.gr)+8
  GAl.gr_left <- resize(GAl.gr_ext,16, fix="start")
  GAl.gr_right <-resize(GAl.gr_ext,16, fix="end")
  left_hits<-findOverlaps(GAl.gr_left,all.GATC)
  right_hits<-findOverlaps(GAl.gr_right,all.GATC)
  #Subset
  damid_reads <- intersect(queryHits(left_hits),queryHits(right_hits))
  GAl.gr_damid <- GAl.gr_ext[damid_reads]
  valid_hits_left <- findOverlaps(GAl.gr_damid,all.GATC,ignore.strand=TRUE, select="first")
  valid_hits_right <- findOverlaps(GAl.gr_damid,all.GATC,ignore.strand=TRUE, select="last")
  GATC_right <- all.GATC[valid_hits_right]
  GATC_left <- all.GATC[valid_hits_left]
  GATC_right <- as(GATC_right,"GRangesList")
  GATC_left <- as(GATC_left,"GRangesList")
  GAl.gr_damid_cropped <- pc(GATC_left,GATC_right)
  GAl.gr_damid_cropped <- unlist(range(GAl.gr_damid_cropped))  
  GAl.gr_damid_cropped 
  names(GAl.gr_damid_cropped)<- names(GAl.gr_damid)
  #<-  lapply(GAl.gr_damid_list, function(x) {
  #                               right <- findOverlaps(x,all.GATC,ignore.strand=TRUE, select="first")
  #                               left <-  findOverlaps(x,all.GATC,ignore.strand=TRUE, select="last") 
  #                               x <- range(all.GATC[right], all.GATC[left])
  #                               return(x)})
  #GAl.gr_damid_cropped <- unlist(as(GAl.gr_damid_cropped, "GRangesList"))
  GAl.gr_damid_cropped <- resize(GAl.gr_damid_cropped,width=width(GAl.gr_damid_cropped)-4, fix="center",use.names=TRUE)
  export(GAl.gr_damid_cropped,paste0("DamID_filtered/",gsub(".bam","_damid.bam",GAlfile)))
  #export(GAl[damid_reads],paste0("DamID_filtered/",gsub(".bam","_damid.bam",GAlfile)))
  GAl.gr_damid_left_50 <- resize(GAl.gr_damid_cropped, width=50, fix="start",use.names=TRUE,ignore.strand=TRUE)
  strand(GAl.gr_damid_left_50) <- "+" 
  names(GAl.gr_damid_left_50) <- paste0(names(GAl.gr_damid_cropped),"_left")
  GAl.gr_damid_right_50 <- resize(GAl.gr_damid_cropped, width=50, fix="end",use.names=TRUE,ignore.strand=TRUE)
  strand(GAl.gr_damid_right_50) <- "-" 
  names(GAl.gr_damid_right_50) <- paste0(names(GAl.gr_damid_cropped),"_right")
  export(c(GAl.gr_damid_left_50, GAl.gr_damid_right_50),paste0("Short_reads/",gsub(".bam","_damid_cropped50.bam",GAlfile)))
    #coverage
  cvg <- coverage(GAl.gr_damid)
  export.bw(cvg,paste0("DamID_filtered/",gsub(".bam","_damid_coverage.bw",GAlfile)))
}

setwd("F:/Peter/Intestine_DamID_2/")
dir.create("DamID_filtered")
dir.create("Short_reads")
file.names <- list.files(pattern="*.bam$")
file.names
for (f in file.names) 
{damid_filtering(f)}






#histogram generation for effect of filtering
#hist(width(GAl.gr), freq=FALSE, xlim=c(0,2000), col="blue", ylim=c(0,0.0020))
#hist(width(GAl.gr_damid), freq=FALSE, xlim=c(0,2000), col="red", ylim=c(0,0.0020))
#gr.original <- hist(width(GAl.gr))
#gr.filtered <- hist(width(GAl.gr_damid))
#plot (c(0,gr.filtered$breaks),gr.original$counts-gr.filtered$counts, xlab="size (bp)", ylab="lost reads", pch="+")




