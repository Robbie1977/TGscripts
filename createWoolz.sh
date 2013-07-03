#!/bin/bash
# SCRIPT:  createWoolz.sh
# PURPOSE: Create woolz files for processed files

FILENAME="/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/FLshow.txt"
count=0
proc=0
logFile="/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/Woolz.log"
proFile="/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/FLwoolz.txt"
. /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/script/initVars.bsh

cat $FILENAME | while read LINE
do
       	let count++
       	echo "$count $LINE"
   		echo "Checking..."
		LSM="$LINE-fastwarp000.tif"
		if [ -e "$LSM" ]
		then
			echo "Converting $LINE ..."
			ls $LINE-fastwarp*.tif > $LINE-BG.txt
			ls $LINE-warpedSig*.tif > $LINE-SG.txt
			script=$woolzDir'WlzExtFFConstruct3D'
			echo "Generating Woolz for: "$LINE
			$script -o $LINE-BG.wlz -f $LINE-BG.txt
			echo "Created BG"
			$script -o $LINE-SG.wlz -f $LINE-SG.txt
			echo "Created SG"
			script=$woolzDir'WlzCompound'
			#cat $LINE-BG.wlz $LINE-SG.wlz | $script > $LINE.wlz.part
			#echo "Created compound"
			#mv $LINE.wlz.part $stacksDir${LINE##/*/}.wlz
			mv $LINE*.wlz $stacksDir


			echo "Chmod & chgrp done!"
			if [ -f  $stacksDir${LINE##"/"*"/"}-SG.wlz ]
			then
			    echo generating woolz: SUCCESS
			    echo $stacksDir${LINE##"/"*"/"}, generating woolz: SUCCESS, $(date +%F\ %X.%N) >> $logFile
			    echo "Removing temp files..."
			    rm $LINE*.tif 
			    rm $LINE*.txt	
			else
			    echo generating woolz: FAILED
			    echo $1, generating woolz: FAILED, $(date +%F\ %X.%N) >> $logFile 	
			fi
			let proc++			
		fi
			    		   		
	
	echo "--------------------------------------------------"
	echo "  $proc out of $count files have been processed"
	echo "--------------------------------------------------"
done

chmod -R 777 $baseDir
chgrp -R flytracker $baseDir

rm $baseDir/logs/tiff/*.txt


