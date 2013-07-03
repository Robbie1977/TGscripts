#!/bin/bash
# SCRIPT:  DICEcheck.sh
# PURPOSE: check if running warpToTemplate.py on DICE machines OK

if [ $(ps x | grep warpToTemplate.py | wc -l) -gt 2 ];
then
	echo Fixing Problem...
	
	ps x | grep DICEwarpToTemplate | cut -b-5 | xargs kill
	ps x | grep VFBTools | cut -b-5 | xargs kill
fi

if [ $(ps x | grep warpToTemplate.py | wc -l) -gt 1 ];
then
	echo Still in Error!!!
	hostname>>~/problem.txt
else
	cd /tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/
	nohup python ../script/DICEwarpToTemplate.py &
	echo Fixed and restarted.
fi






