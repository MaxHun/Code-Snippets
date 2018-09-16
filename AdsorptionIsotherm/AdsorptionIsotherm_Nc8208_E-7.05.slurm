#!/bin/bash
#SBATCH -J AI_Nc8208_E-7.05.slurm
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)

#SBATCH --error=AI_Nc8208_E-7.05-%j.err
#SBATCH --output=AI_Nc8208_E-7.05-%j.out

### load the module
module load slurm/15.08.8

hostname
cd /beetmp/huneshagen/tmp/
mkdir $SLURM_JOB_ID
cd $SLURM_JOB_ID
echo Running on host
hostname
pwd

#### copy initial data from home to local disk ####
echo 'copy file to node'

cp /beetmp/huneshagen/bin/AnalyzerAdsorptionIsotherm .



### run my job > sending status to home ####
srun ./AnalyzerAdsorptionIsotherm -m 10000000 -s 100 -n 8208 -e -7.05

##! IMPORTANT: copy back results
echo 'copy file back to project'
cp * $SLURM_SUBMIT_DIR
cd ..
##! IMPORTANT: cleaning up after myself
echo 'delete file on node'
rm -rf $SLURM_JOB_ID
