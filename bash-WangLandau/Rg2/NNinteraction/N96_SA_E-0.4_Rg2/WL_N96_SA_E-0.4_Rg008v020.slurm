#!/bin/bash
#SBATCH -J WL_N96_SA_E-0.4_Rg008v020.slurm
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks=1   # number of processor cores (i.e. tasks)

#SBATCH --error=WL_N96_SA_E-0.4_Rg008v020-%j.err
#SBATCH --output=WL_N96_SA_E-0.4_Rg008v020-%j.out

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

cp /beetmp/huneshagen/bin/WangLandauSimulatorNextNeighborAdaptiveWindowSimulationRun .
cp $SLURM_SUBMIT_DIR/LinearChain_N96_PerXYZ128_Solvent_008v020.bfm .
cp $SLURM_SUBMIT_DIR/LinearChain_N96_PerXYZ128_final_HGLnDOS_shifted.dat .


### run my job > sending status to home ####
srun ./WangLandauSimulatorNextNeighborAdaptiveWindowSimulationRun -i LinearChain_N96_PerXYZ128_Solvent_008v020.bfm  --min -30001.05 --max 1.05 --bins 300021 -m 100000000000 -s 200 --min-statistic 5000 --min-win -153.6 --max-win -125.4 --HGLnDOS LinearChain_N96_PerXYZ128_final_HGLnDOS_shifted.dat

##! IMPORTANT: copy back results
echo 'copy file back to project'
cp * $SLURM_SUBMIT_DIR/results
cd ..
##! IMPORTANT: cleaning up after myself
echo 'delete file on node'
rm -rf $SLURM_JOB_ID
