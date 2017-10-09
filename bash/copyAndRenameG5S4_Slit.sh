#!/bin/bash


oldfile="MyDendrimer_G5_S4_f3_N373_PerXY256_NoPerZ0_Slit.bfm"
oldfileSlurm="SimMyDendrimer_G5_S4_f3_N373_PerXY256_NoPerZ0_Slit.slurm"

for slit in $(echo "for (i=10;i<=256;i+=1) i"|bc)
do 
    echo $slit
    newFile="NoPerZ"$slit"_Slit"
    ./CreateDendrimerGeneral_FGS -o MyDendrimer_G5_S4_f3_N373_PerXY256_$newFile.bfm -f 3 -g 5 -s 4 -x 256 -y 256 -z $slit
#    cp $oldfile "${oldfile/K0.75_L0/$newFile}"
    cp $oldfileSlurm "${oldfileSlurm/NoPerZ0_Slit/$newFile}"
#    sed -i 's/#!virtual_spring_length=0/#!virtual_spring_length='$springlength'/g' "${oldfile/K0.75_L0/$newFile}"
    sed -i 's/NoPerZ0_Slit/'$newFile'/g' "${oldfileSlurm/NoPerZ0_Slit/$newFile}"
done


