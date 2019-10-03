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
####### minimap
##############################

curl -L https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17_x64-linux.tar.bz2 | tar -jxvf -./minimap2


##############################
####### guppy
##############################

GUPPY_VERSION="3.1.5"

rm -rf ./ont-guppy
wget https://mirror.oxfordnanoportal.com/software/analysis/ont-guppy_${GUPPY_VERSION}_linux64.tar.gz
tar -xzvf ont-guppy_${GUPPY_VERSION}_linux64.tar.gz

echo "export GUPPY_DIR=${SOFTWARE_DIR}/ont-guppy/bin" >> ~/.bashrc


##############################
####### deepbinner
##############################

pip install tensorflow-gpu==1.14

rm -rf ./Deepbinner
git clone https://github.com/rrwick/Deepbinner.git
pip install ./Deepbinner
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
* Place all the fast5 files in a folder multi_fast5 folder (or if they are single fast5s in a folder called single_fast5). You can use other names for these folders but then you have to change them in the varSettings.sh file
* clone this git repository into a folder called "scripts"
```
git clone https://github.com/CellFateNucOrg/basic_ont.git scripts/
```

* In the scripts directory copy varSettings_example.sh to varSettings.sh, then edit varSettings.sh according to your experiment. 
* The scripts are numbered according to the order you should run them in:
- 01_runMultiToSingleFast5.sh to convert multi-fast5 files to single-fast5 files. Also does QC with pycoQC
- 02_runBasecallGuppy.sh basecall single reads with guppy
- 03_runBinBarcodes.sh uses deepbinner to bin the barcodes
- 04_runMinimap.sh maps the reads by barcode to the genome (defined in varSettings) with minimap2

The scripts are run on the server with the SBATCH command:
```
sbatch nameOfScript.sh
```










