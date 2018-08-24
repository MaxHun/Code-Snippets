#!/bin/bash

#array=$(ls | grep -a 'final_HGLnDOS')
array=(*final_HGLnDOS*)

echo $array
# get length of an array
arraylength=${#array[@]}


python3 OverlapAndAverage.py ${array[0]} ${array[1]} "out.dat"

for (( i=2; i<${arraylength}; i++ ));
do
  echo $i " / " ${arraylength} " : " ${array[$i]}
  winOne="out.dat" #${array[$i]}
  winTwo=${array[$i]}
  winOut="out.dat"
  
  python3 OverlapAndAverage.py $winOne $winTwo $winOut
  
done

python3 ShiftToZero.py "out.dat" ${array[0]%.bfm*}"_HGLnDOS_shifted.dat"
