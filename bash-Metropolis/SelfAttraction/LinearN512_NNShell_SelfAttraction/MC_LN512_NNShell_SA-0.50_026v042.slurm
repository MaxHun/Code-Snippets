#!/bin/bash
#SBATCH -J MC_LN512_NNShell_SA-0.50_026v042.slurm
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)

#SBATCH --error=MC_LN512_NNShell_SA-0.50_026v042-%j.err
#SBATCH --output=MC_LN512_NNShell_SA-0.50_026v042-%j.out

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

cp /beetmp/huneshagen/bin/SimpleSimulatorNextNeighborInteraction .
cp $SLURM_SUBMIT_DIR/LinearChain_N512_PerXYZ128_NNShell_SA_E-0.50_026v042.bfm .



### run my job > sending status to home ####
srun ./SimpleSimulatorNextNeighborInteraction LinearChain_N512_PerXYZ128_NNShell_SA_E-0.50_026v042.bfm 1000000000 10000

##! IMPORTANT: copy back results
echo 'copy file back to project'
cp * $SLURM_SUBMIT_DIR
cd ..
##! IMPORTANT: cleaning up after myself
echo 'delete file on node'
rm -rf $SLURM_JOB_ID
