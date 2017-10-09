#!/bin/bash
#exit
springconstant=0.75
#cd /scratch/ClusterJobs20120903/ClusterJobs/Oscillatory/Ring_real_N200/
mkdir MyDendrimer_G8_S4_f3_N3061_PerXY256_NoPerZ256_"K"$springconstant
cp MyDendrimer_G8_S4_f3_N3061_PerXY256_NoPerZ256_K0.75_L0.bfm ./MyDendrimer_G8_S4_f3_N3061_PerXY256_NoPerZ256_"K"$springconstant
cp SimMyDendrimer_G8_S4_f3_N3061_PerXY256_NoPerZ256_K0.75_L0.slurm ./MyDendrimer_G8_S4_f3_N3061_PerXY256_NoPerZ256_"K"$springconstant

cd MyDendrimer_G8_S4_f3_N3061_PerXY256_NoPerZ256_"K"$springconstant

oldfile="MyDendrimer_G8_S4_f3_N3061_PerXY256_NoPerZ256_K0.75_L0.bfm"
oldfileSlurm="SimMyDendrimer_G8_S4_f3_N3061_PerXY256_NoPerZ256_K0.75_L0.slurm"

for springlength in $(echo "for (i=1;i<=96;i+=1) i"|bc)
do 
    echo $springlength
    newFile="K"$springconstant"_L"$springlength
    echo $newFile
    cp $oldfile "${oldfile/K0.75_L0/$newFile}"
    cp $oldfileSlurm "${oldfileSlurm/K0.75_L0/$newFile}"
    sed -i 's/#!virtual_spring_length=0/#!virtual_spring_length='$springlength'/g' "${oldfile/K0.75_L0/$newFile}"
    sed -i 's/K0.75_L0/'$newFile'/g' "${oldfileSlurm/K0.75_L0/$newFile}"
done


