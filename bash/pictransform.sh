 convert dendr_g7_s4_b128_l24_solv_hysteresis_nosolv_000002.png label:'R. Dockhorn (2016)' -gravity Center -append dendr.png
 
 convert dendr_g7_s4_b128_l24_solv_hysteresis_nosolv_000002.png -fill white  -undercolor '#00000080'  -gravity SouthWest -annotate +0+5 'R. Dockhorn (2016)' dendr2.png
 
 convert dendr_g7_s4_b128_l24_solv_hysteresis_nosolv_000002.png -fill white  -gravity SouthWest -pointsize 14 -annotate +0+5 'R. Dockhorn (2016)' dendr2b.png
 
 convert dendr_g7_s4_b128_l24_solv_hysteresis_nosolv_000002.png -pointsize 36 -font /usr/share/fonts/truetype/Roboto-Regular.ttf -fill white  -undercolor '#00000080'  -gravity NorthEast -annotate +0+5 ' ε = 0.01' dendr3.png
 
 

for i in *.pov; do output="+O$(basename $i .pov)".png; povray +I$i $output +W800 +H689; done

for i in *.png; do convert $i -resize 800x688! $i; done

for i in *.png; do convert $i -fill white  -gravity SouthWest -pointsize 14 -annotate +5+5 'R. Dockhorn (2016)' $i; done

ffmpeg -framerate 25 -i dendr_g7_s4_b128_l24_solv_hysteresis_nosolv_00%04d.png -c:v libx264 -vf fps=25 -pix_fmt yuv420p micelles.mp4
