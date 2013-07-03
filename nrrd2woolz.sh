#!/bin/bash
#
function pause(){
   read -p "$*"
}



FijiDir=/disk/data/VFBTools/Fiji.145/fiji-linux64
Nrrd2Tif=../script/nrrd2tif.ijm
FILES=./outtray/GMR*BGwarp.nrrd
WLZ=/disk/data/VFBTools/Woolz2013Full/bin/

for f in $FILES
do
  echo "Processing $f file..."
  t=$(echo $f | sed 's/nrrd/tif/g')
  python ../script/Bound.py 2 $f
  ${FijiDir} -macro ${Nrrd2Tif} ${f} -batch
  if [ -s $t ] 
    then
        echo "Tiff file $t created OK"
        echo "Converting to woolz..."
        d=$(echo $f | sed 's/\-PP\-BGwarp\.nrrd//g' | cut -c 11- )
        c=$(echo "../stacks/${d}/wlz/BG.wlz")
        mkdir -pv ../stacks/$d/wlz
        ${WLZ}WlzExtFFConvert -f tif -F wlz $t | ${WLZ}WlzThreshold -v2 > $c
        if [ -s $c ]
            then
                echo "Tiff file $t created OK"
                echo "Converting Signal..."
                sf=$(echo $f | sed 's/BG/SG/g')
                echo "Processing $sf file..."
                python ../script/Bound.py 2 $sf
                st=$(echo $sf | sed 's/nrrd/tif/g')
                $FijiDir -macro $Nrrd2Tif $sf -batch
                if [ -s $st ] 
                    then
                        echo "Tiff file $st created OK"
                        echo "Converting to woolz..."
                        sc=$(echo "../stacks/${d}/wlz/SG.wlz")
                        ${WLZ}WlzExtFFConvert -f tif -F wlz $st | ${WLZ}WlzThreshold -v2 > $sc 
                        if [ -s $sc ]
                            then
                                echo "Completed OK!"
                            else
                                echo "FAILED to create SG woolz file!"
                        fi 
                    else
                        echo "Signal tiff creation FAILED"
                fi
            else
                echo "FAILED to create woolz BG file"
        fi
    else
        echo "FAILED to create $t"
  fi
  #pause 'Press [Enter] key to continue...'
done
