#!/bin/bash
#

rm progress.csv 

for (( y=2012; y<=2013; y++ ))
do

for (( m=1; m<=12; m++ ))
do
	for (( d=1; d<=30; d++ ))
	do
		da=`printf "%04d" $y`-`printf "%02d" $m`-`printf "%02d" $d`
		ct=$(cat Warp.log | grep Finished | grep "$da " | grep BG | wc -l)
		echo $da, $ct
		echo $da, $ct >> progress.csv
		if [ $(date +%Y-%m-%d) == $da ];
		then    
		    for (( h=0; h<=23; h++ ))
		    do
		        ha=$da" "`printf "%02d" $h` 
		        ct=$(cat Warp.log | grep Finished | grep "$ha" | grep BG | wc -l)  
		        echo ..$ha, $ct
		    done
		fi  
	done
done

done
