#!/bin/bash
# SCRIPT:  DICEcheck.sh
# PURPOSE: check if running warpToTemplate.py on DICE machines OK
if [ $(pgrep -f warpToTemplate | wc -l) -gt 0 ];
then
	if [ $(pgrep -f warpToTemplate | wc -l) -gt 1 ];
	then
		echo Problem...
		hostname>>~/problem.txt
	fi	
else
    if [ $(pgrep -f DICEconf | wc -l) -gt 0 ];
    then
        echo Trying backup process...
        ~/DICE1conf.sh
    fi
	if [ $(pgrep -f DICEconf | wc -l) -gt 0 ];
	then
		echo Problem...
                hostname>>~/problem.txt
		pgrep -f DICEconf | wc -l>>~/problem.txt
	else
		hn=$(hostname)
		pc=$(cat /proc/cpuinfo | grep processor | wc -l)
		uc=$(w -h | wc -l)
		echo $pc' ('$uc') '$hn >>~/potential.txt 
		if [ $uc -lt 1 ];
		then
		    nohup ~/DICEconf.sh &
		fi
	fi
fi



