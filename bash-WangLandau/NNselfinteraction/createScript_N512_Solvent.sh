#!bin/bash

nameFolder="N512_Solvent"

newFileBase="WL_N512Solv_NNShell"

newBFMFileBase="LinearChain_N512_PerXYZ128_Solvent"

mkdir $nameFolder

#array=(1.0 $(seq -20.0 -50.0 -240.0)  -350.0)
# !!! Absteigende Reihenfolge !!!
#array=(6000.0 $(seq 5600.0 -300.0 100.0) -1.0)
array=( 0.0   -102.4  -204.8  -307.2  -409.6  -512.0   -614.4  -716.8  -819.2 -921.6 -1024.0  -1126.4 -1228.8 -1331.2 -1433.6 -1536.0  -1638.4 -1740.8 -1843.2 -1945.6 -2048.0)

#overlap=20.0
overlap=48

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

