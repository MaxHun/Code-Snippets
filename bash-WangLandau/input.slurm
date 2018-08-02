#!/bin/bash
#SBATCH -J input.slurm
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)

#SBATCH --error=input-%j.err
#SBATCH --output=input-%j.out

### load the module
module load slurm/15.08.8

hostname
cd /beetmp/dockhorn/tmp/
mkdir $SLURM_JOB_ID
cd $SLURM_JOB_ID
echo Running on host
hostname
pwd

#### copy initial data from home to local disk ####
echo 'copy file to node'

cp /beetmp/dockhorn/bin/WangLandauSimulatorNextNeighborAdaptiveWindow .
cp $SLURM_SUBMIT_DIR/BFM.bfm .



### run my job > sending status to home ####
srun ./WangLandauSimulatorNextNeighborAdaptiveWindow -i BFM.bfm -o out.bfm --min MINHISTO --max MAXHISTO --bins BINS -m 100000000000 -s SAVEMCS -b HISTOCHECK -f 1.01 --min-win MINWIN --max-win MAXWIN

##! IMPORTANT: copy back results
echo 'copy file back to project'
cp * $SLURM_SUBMIT_DIR
cd ..
##! IMPORTANT: cleaning up after myself
echo 'delete file on node'
rm -rf $SLURM_JOB_ID
