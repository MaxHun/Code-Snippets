#!bin/bash

nameFolder="LinearN256_NNShell_SelfAttraction"

newFileBase="MC_LN256_NNShell_SA"

newBFMFileBase="LinearChain_N256_PerXYZ128_NNShell_SA_E"

mkdir $nameFolder

array=(-0.01 $(seq -0.02 -0.02 -0.80) -1.00)

# get length of an array
arraylength=${#array[@]}

save=5000
maxMCS=500000000

# use for loop to read all values and indexes
for (( i=0; i<${arraylength}; i++ ));
do
  echo $i " / " ${arraylength} " : " ${array[$i]}
  
  
  postfix=$(echo $(echo "scale=8; ${array[$i]}" | bc) | awk '{printf "%1.2f\n", $1}')"_"$(echo $(echo "scale=8; ${i}+1" | bc) | awk '{printf "%03d\n", $1}')"v"$(echo $(echo "scale=8; ${arraylength}" | bc) | awk '{printf "%03d\n", $1}')
  
  newFileBaseSlurm=$newFileBase$postfix
  
  cp "input_SA.slurm" $nameFolder"/"$newFileBaseSlurm".slurm"
  newFile=$newBFMFileBase$postfix
  cp $newBFMFileBase".bfm" $nameFolder"/"$newFile".bfm"
  
  sed -i 's/input/'$newFileBaseSlurm'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/BFM/'$newFile'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/SAVEMCS/'$save'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/MAXMCS/'$maxMCS'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  
  sed -i 's/NNINTERACTION/'${array[$i]}'/g' $nameFolder"/"$newFile".bfm"
  
done

