#!/bin/bash
# SCRIPT:  DICEconf.sh
# PURPOSE: configure and run warpToTemplate.py on DICE machines

if [ ! -d /tmp/VFBproc -a ! -d /tmp/VFBproc1 ]; 
then
	echo Setting up directories... 
	mkdir /tmp/VFBproc
fi

if [ ! -d /tmp/VFBproc/VFB -a ! -d /tmp/VFBproc1/VFB ]; 
then
	echo Setting up sshfs link...
        sshfs -p 22 karenin:/disk/data/ /tmp/VFBproc/
	cd /tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/

	if [ $(ps x | grep warpToTemplate.py | wc -l) -gt 1 ];
	then
    		echo Already on it.
	else
    		echo Starting script...
        	nohup python ../script/dicePARTwarpToTemplate.py &
	fi

fi

hostname>>~/machinesP.txt
ps x | grep warpToTemplate | wc -l>>~/machinesP.txt
echo Running....




