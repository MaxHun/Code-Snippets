 
#!/bin/bash

i="0"
z="0"
energy="0.01"

filenamepre="dendr_g7_s4_b128_l24_solv_hysteresis_nosolv_00"
file=""
filePovrayIn=""
filePovrayOut=""

rColor=$(echo "scale=4; (57/255)" | bc)
gColor=$(echo "scale=4; (73/255)" | bc)
bColor=$(echo "scale=4; (96/255)" | bc)


redOne=$(echo "scale=4; (57/255)" | bc)
greenOne=$(echo "scale=4; (73/255)" | bc)
blueOne=$(echo "scale=4; (96/255)" | bc)


redTwo=$(echo "scale=4; (80/255)" | bc)
greenTwo=$(echo "scale=4; (93/255)" | bc)
blueTwo=$(echo "scale=4; (143/255)" | bc)


redThree=$(echo "scale=4; (50/255)" | bc)
greenThree=$(echo "scale=4; (109/255)" | bc)
blueThree=$(echo "scale=4; (165/255)" | bc)


redFour=$(echo "scale=4; (47/255)" | bc)
greenFour=$(echo "scale=4; (120/255)" | bc)
blueFour=$(echo "scale=4; (224/255)" | bc)




while [ $i -lt 1590 ]
do
i=$[$i+1]

file=$filenamepre$(echo "$i" | awk '{printf "%04d\n", $1}').png
filePovrayIn=$filenamepre$(echo "$i" | awk '{printf "%04d\n", $1}').pov
filePovrayOut=$filenamepre$(echo "$i" | awk '{printf "%04d\n", $1}').png

let "z = $i % 10"
echo $i" "$z" "$energy" "$file

tparam=$(echo "scale=4; ($energy-0.01)/(0.80-0.01)" | bc)

rColor=$(echo "scale=4; $redOne*(1.0-$tparam)*(1.0-$tparam)*(1.0-$tparam)+3.0*$redTwo*$tparam*(1.0-$tparam)*(1.0-$tparam)+3.0*$redThree*(1.0-$tparam)*$tparam*$tparam+$redFour*$tparam*$tparam*$tparam" | bc)
# rColor=$(echo "scale=4; $redStart+($redEnd-$redStart)*($energy-0.01)/(0.80-0.01)" | bc)

gColor=$(echo "scale=4; $greenOne*(1.0-$tparam)*(1.0-$tparam)*(1.0-$tparam)+3.0*$greenTwo*$tparam*(1.0-$tparam)*(1.0-$tparam)+3.0*$greenThree*(1.0-$tparam)*$tparam*$tparam+$greenFour*$tparam*$tparam*$tparam" | bc)
# gColor=$(echo "scale=4; $greenStart+($greenEnd-$greenStart)*($energy-0.01)/(0.80-0.01)" | bc)

bColor=$(echo "scale=4; $blueOne*(1.0-$tparam)*(1.0-$tparam)*(1.0-$tparam)+3.0*$blueTwo*$tparam*(1.0-$tparam)*(1.0-$tparam)+3.0*$blueThree*(1.0-$tparam)*$tparam*$tparam+$blueFour*$tparam*$tparam*$tparam" | bc)
#bColor=$(echo "scale=4; $blueStart+($blueEnd-$blueStart)*($energy-0.01)/(0.80-0.01)" | bc)



sed -i "s/location <0 , 0 , 183 >/location <0 , -10 , 183+30+90 >/g" $filePovrayIn

sed -i "s%650/650%1366/768%g" $filePovrayIn

#sed -i "s/sky_sphere{pigment{color rgb< 0, 0, 0> }}/sky_sphere{pigment{color rgb< $rColor, $gColor, $bColor> }}/g" $filePovrayIn
sed -i "s/sky_sphere{pigment{color rgb< 0, 0, 0> }}/sphere{ <0,0,0>,1 texture{ pigment{ color rgb< $rColor, $gColor, $bColor> } finish { ambient 0.2 diffuse 0.6}} scale 450}/g" $filePovrayIn

sed -i "s%plane {     z, -1     pigment%//plane {     z, 4.9     pigment%g" $filePovrayIn

sed -i "s/scale 64 translate <32 , 32 , 0>/scale 64 translate <32 , 32 , 5>/g" $filePovrayIn

sed -i "s/color Gray30/color Gray80/g" $filePovrayIn

sed -i "s%box%//box%g" $filePovrayIn

sed -i "s/light_source{< 0 , -10 , 183-64 > color White/light_source{< 0 , -10 , 183-64+30+90 > color White/g" $filePovrayIn

sed -i "s/pigment {color rgb<0, 0, 1>}/pigment {color rgb<0.99, 0.99, 0>}/g" $filePovrayIn

sed -i "s/pigment {color rgb<1, 1, 0>}/pigment {color rgb<0, 0, 0.99>}/g" $filePovrayIn

#sed -i "s%color_map{ [0.0 color rgb<0, 0, 1> ][1.0 color rgb<0, 0, 1> ]}%color_map{ [0.0 color rgb<0.99, 0.99, 0> ][1.0 color rgb<0.99, 0.99, 0> ]}%g" $filePovrayIn
sed -i "s%0.0 color rgb<0, 0, 1>%0.0 color rgb<0.99, 0.99, 0>%g" $filePovrayIn
sed -i "s%1.0 color rgb<0, 0, 1>%1.0 color rgb<0.99, 0.99, 0>%g" $filePovrayIn

#sed -i "s%color_map{ [0.0 color rgb<1, 1, 0> ][1.0 color rgb<1, 1, 0> ]}%color_map{ [0.0 color rgb<0, 0, 0.99> ][1.0 color rgb<0, 0, 0.99> ]}%g" $filePovrayIn
sed -i "s%0.0 color rgb<1, 1, 0>%0.0 color rgb<0, 0, 0.99>%g" $filePovrayIn
sed -i "s%1.0 color rgb<1, 1, 0>%1.0 color rgb<0, 0, 0.99>%g" $filePovrayIn
#sed -i "s/\[\([^]]*\)\]/[0.0 color rgb<0.99, 0.99, 0> ][1.0 color rgb<0.99, 0.99, 0> ]/g" $filePovrayIn


povray "+I"$filePovrayIn " +O"$filePovrayOut +W1366 +H768

#convert $file -pointsize 36 -font /usr/share/fonts/truetype/Roboto-Regular.ttf -fill white   -gravity NorthEast -annotate +10+10 ' ε = '$energy $file


#convert $file -fill white  -gravity SouthWest -pointsize 18 -annotate +5+5 'R. Dockhorn; M. Wengenmayr; J.-U. Sommer (2016)' $file



if [ "$z" -eq "0" ]
then
  if [ $i -gt 799 ]
  then
    energy=$(echo "$energy-0.01" | awk '{printf "%.2f \n", $1-0.01}')
  else
    energy=$(echo "$energy+0.01" | awk '{printf "%.2f \n", $1+0.01}')
  fi
fi

done

ffmpeg -framerate 25 -i dendr_g7_s4_b128_l24_solv_hysteresis_nosolv_00%04d.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p dendr_g7_s4_multimicelle_f25.mp4
#ffmpeg -framerate 12 -i dendr_g7_s4_b128_l24_solv_hysteresis_nosolv_00%04d.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p dendr_g7_s4_multimicelle_f12.mp4
