#!/bin/bash
# SCRIPT:  loadtrays.sh
# PURPOSE: Uncompress, copy for processing then recompress original LSM files.

FILENAME="/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/rPLpre.txt"
count=0
proc=0
numfiles=(intray/*)
numfiles=${#numfiles[@]}
echo "intray has $numfiles waiting..." 
proc=$numfiles 

cat $FILENAME | while read LINE
do
    let count++
    echo "$count $LINE"
    while [ $proc -gt 30 ]
    do
        sleep 5m
        numfiles=(intray/*)
        numfiles=${#numfiles[@]}
        echo "intray has $numfiles waiting..." 
        proc=$numfiles 
    done
    LSM="$LINE"
    GZ="$LINE.gz"
    if [ -e $GZ ]
    then
        echo "Un-compressing $GZ ..."
	nice gunzip "$GZ"
	sleep 5
	if [ -e "$LSM" ]
	then   
	    echo "copying to intray..."
	    nice cp "$LSM" "intray/"
	    echo "compressing original file $LSM ..."
	    nice nohup gzip "$LSM" &
	    let proc++
	    sleep 5
	fi
    else
       	echo "Not yet compressed"
	LSM="$LINE"
        GZ="$LINE.gz"
	if [ -e "$LSM" ]
	then
	   echo "copying to intray..."
	   nice cp "$LSM" "intray/"
	   echo "compressing original file $LSM ..."
	   nice nohup gzip "$LSM" &
	   let proc++
	fi
    fi
    
done

