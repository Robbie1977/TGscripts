#!/bin/bash
# SCRIPT:  qzipBrainOriginalLsmFiles.sh
# PURPOSE: Compress original LSM files after pre-processing

FILENAME="/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/FLBpre.txt"
count=0
zipped=0
unzipped=0
proc=0
cat $FILENAME | while read LINE
do
       	let count++
       	echo "$count $LINE"
	case "$LINE" in
	*-Done*)
    		echo "Checking..."
		let proc++
		LSM=${LINE%' -Done'}
		if [ -e "$LSM" ]
		then
			echo "Compressing $LSM ..."
			if [ `ps x | wc -l` -lt 30 ]
			then
				nice nohup gzip "$LSM" &
			else
				nice gzip "$LSM"
			fi
			let zipped++			
		fi
		;;
	*)
    		echo "Not yet processed"
		LSM="$LINE.gz"
		if [ -e "$LSM" ]
		then
			echo "Un-compressing $LSM ..."
			nice gunzip "$LSM"
			let unzipped++			
		fi
    		;;
	esac
	echo "--------------------------------------------------"
	echo " $zipped files zipped out of $proc processed files" 
	echo "$proc out of $count files have been pre-processed"
	echo "$unzipped files unzipped"
	echo "--------------------------------------------------"
done

