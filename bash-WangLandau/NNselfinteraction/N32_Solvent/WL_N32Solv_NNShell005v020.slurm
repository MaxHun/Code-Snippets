#!/bin/bash
#SBATCH -J WL_N32Solv_NNShell005v020.slurm
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)

#SBATCH --error=WL_N32Solv_NNShell005v020-%j.err
#SBATCH --output=WL_N32Solv_NNShell005v020-%j.out

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

cp /beetmp/huneshagen/bin/WangLandauSimulatorNextNeighbor .
cp $SLURM_SUBMIT_DIR/LinearChain_N32_PerXYZ128_Solvent_005v020.bfm .



### run my job > sending status to home ####
srun ./WangLandauSimulatorNextNeighborAdaptiveWindow -i LinearChain_N32_PerXYZ128_Solvent_005v020.bfm -o out.bfm --min -30001.05 --max 1.05 --bins 300021 -m 100000000000 -s 500000 -b 500000 -f 1.01 --min-win -32.0 --max-win -22.6

##! IMPORTANT: copy back results
echo 'copy file back to project'
cp * $SLURM_SUBMIT_DIR
cd ..
##! IMPORTANT: cleaning up after myself
echo 'delete file on node'
rm -rf $SLURM_JOB_ID
