#!bin/bash

nameFolder="N64_E-0.4_c2_Solvent"

newFileBase="WL_N64_E-0.4_c2_Solv_NNShell"

newBFMFileBase="LinearChain_N64_E-0.4_c2_PerXYZ64_Solvent"

mkdir $nameFolder

#array=(1.0 $(seq -20.0 -50.0 -240.0)  -350.0)
# !!! Absteigende Reihenfolge !!!
#array=(6000.0 $(seq 5600.0 -300.0 100.0) -1.0)
array=(-100.0  -250.0  -500.0  -750.0 -1000.0 -1250.0 -1500.0 -1750.0 -2000.0 -2250.0 -2500.0)

#overlap=20.0
overlap=100

maxhisto=1.05
minhisto=-30001.05
bins=300021

save=500000
histogramcheck=500000


# get length of an array
arraylength=${#array[@]}

# use for loop to read all values and indexes
for (( i=0; i<${arraylength}-1; i++ ));
do
  echo $i " / " ${arraylength} " : " ${array[$i]}
  minwin=${array[$i+1]}
  maxwin=$(echo "scale=8; ${array[$i]}+${overlap}" | bc)
  echo $i " min/max = (" ${minwin} " : " ${maxwin} ")"
  
  postfix=$(echo $(echo "scale=8; ${i}+1" | bc) | awk '{printf "%03d\n", $1}')"v"$(echo $(echo "scale=8; ${arraylength}-1" | bc) | awk '{printf "%03d\n", $1}')
  
  newFileBaseSlurm=$newFileBase$postfix
  
  cp "input.slurm" $nameFolder"/"$newFileBaseSlurm".slurm"
  newFile=$newBFMFileBase"_"$postfix
  cp $newBFMFileBase".bfm" $nameFolder"/"$newFile".bfm"
  
  sed -i 's/input/'$newFileBaseSlurm'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/BFM/'$newFile'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/MINWIN/'$minwin'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/MAXWIN/'$maxwin'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/MINHISTO/'$minhisto'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/MAXHISTO/'$maxhisto'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/BINS/'$bins'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/SAVEMCS/'$save'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  sed -i 's/HISTOCHECK/'$histogramcheck'/g' $nameFolder"/"$newFileBaseSlurm".slurm"
  
done

