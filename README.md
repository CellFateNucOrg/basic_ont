# basic_ont

# Setting up the environment
Find or create a directory for software in your home directory. Below it is assumed the directory is called "software" 
```
ls ~/
SOFTWARE_DIR=${HOME}/software
mkdir -p ${SOFTWARE_DIR}
cd $SOFTWARE_DIR
echo "Installing software from BASIC_ONT in " ${SOFTWARE_DIR}
```

Then run the following code:
```
# dealing with miniconda vs anaconda installations
CONDA_PACKAGE=`which conda`
if [ ! ${CONDA_PACKAGE} ]; 
then 
	echo "Check if anaconda or miniconda is installed in the home directory";
    exit
fi

echo "export CONDA_ACTIVATE=${CONDA_PACKAGE%conda}activate" >> ~/.bashrc
source ~/.bashrc

PYTHON_VERSION="3.6"

conda create -n BASIC_ONT python=${PYTHON_VERSION}
source ${CONDA_ACTIVATE} BASIC_ONT

##############################
####### multi_to_single_fast5 
##############################

git clone https://github.com/nanoporetech/ont_fast5_api
cd ont_fast5_api
python setup.py install


##############################
####### pycoQC
##############################

conda install -c aleg pycoqc


##############################
####### minimap2
##############################

curl -L https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17_x64-linux.tar.bz2 | tar -jxvf -./minimap2


##############################
####### samtools 
##############################

conda install -c bioconda samtools

##############################
####### guppy
##############################

GUPPY_VERSION="3.4.3"

rm -rf ./ont-guppy
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy_${GUPPY_VERSION}_linux64.tar.gz
tar -xzvf ont-guppy_${GUPPY_VERSION}_linux64.tar.gz

echo "export GUPPY_DIR=${SOFTWARE_DIR}/ont-guppy/bin" >> ~/.bashrc


##############################
####### deepbinner
##############################

** no longer necessary**
pip install tensorflow-gpu==1.14

rm -rf ./Deepbinner
git clone https://github.com/rrwick/Deepbinner.git
pip install ./Deepbinner


##############################
####### R
##############################
Rinstalled=`which R`
if [ -z ${Rinstalled} ] 
then
  conda install -c r r-base r-essentials
  conda install -c bioconda bioconductor-biocinstaller
else
  echo ""
  echo "Detected existing R installation "${Rinstalled}
fi
```

Any packages required need to be installed manually by starting R and installing them on the command line.


```
To activate the envinronment interactively you can type:
```
conda activate BASIC_ONT
```
To activate the envinronment inside a script running on the server, type:
```
source ${CONDA_ACTIVATE} BASIC_ONT
```

# Analysing data
* Create a folder with the name of your experiment. 
* Move inside this directory. 
* Place all the fast5 files in a folder called multi_fast5, or if you have single fast5s, put them in a folder called single_fast5. (Note: You can use other names for these folders but then you have to change them in the varSettings.sh file).
* clone the basic_ont git repository into a folder called "scripts":
```
git clone https://github.com/CellFateNucOrg/basic_ont.git scripts/
```

* In the scripts directory copy __varSettings_example.sh__ to __varSettings.sh__, then edit varSettings.sh according to your experiment. This ensures that when you update code from git, your folder-specific settings are not overwritten.
* The scripts are numbered according to the order you should run them in:
- __01_runMultiToSingleFast5.sh__ to convert multi-fast5 files to single-fast5 files. 
- __02_runBasecallGuppy.sh__ basecall single reads with guppy. Also does QC with pycoQC.
- __03_runBinBarcodes.sh__ uses deepbinner to bin the barcodes.
- __04_runMinimap.sh__ maps the reads by barcode to the genome (defined in varSettings) with minimap2.
- __05_runDamIdFiltering.sh__ filters the reads from the bam file (this runs the DamID_Filtering.R script).

The scripts are run on the server with the SBATCH command:
```
sbatch nameOfScript.sh
```

IMPORTANT NOTE:

When running the mapping script __04_runMinimap.sh__ you should make sure to:

a) list all the __barcodes used__ in the __varSettings.sh__ file

b) modify the __04_runMinimap.sh__ script to run as many array jobs as barcodes used. 

e.g. setting "#SBATCH --array=1-3" in the 04_runMinimap.sh file will run the first three barcodes listed in barcodesUsed, each as an individual job. So if you used barcodes 2 3 and 5, barcodesUsed should be defined in the varSettings.sh file as: barcodesUsed=( barcode02 barcode03 barcode05 ).








