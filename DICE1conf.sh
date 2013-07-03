#!/bin/bash
# SCRIPT:  DICEconf.sh
# PURPOSE: configure and run warpToTemplate.py on DICE machines

pgrep -u s1002628 -f 'karenin:/disk/data/ /tmp/VFBproc/' | xargs kill -9 

exit_code=0
if [ ! -d /tmp/VFBproc1 ]; 
then
	echo Setting up 1st directory... 
	mkdir /tmp/VFBproc1
	exit_code=$?
fi

if [ exit_code == 0 ]; then

	if [ ! -d /tmp/VFBproc1/VFBTools ]; then
		echo Setting up sshfs link...
        	sshfs -p 22 karenin:/disk/data/ /tmp/VFBproc1/ -o reconnect -C -o workaround=all
		cd /tmp/VFBproc1/VFB/IMAGE_DATA/Janelia2012/TG/logs/

		if [ $(ps x | grep warpToTemplate.py | wc -l) -gt 1 ]; then
    			echo Already on it.
		else
    			echo Starting script...
        		nohup nice python ../script/DICE1warpToTemplate.py &
		fi

	fi

else

	exit_code=0
	if [ ! -d /tmp/VFBproc3 ]; then
    		echo Setting up 3rd directory...
        	mkdir /tmp/VFBproc3
        	exit_code=$?
	fi

	#if [ exit_code == 0 ]; then

		if [ ! -d /tmp/VFBproc3/VFBTools ]; then
	    		echo Setting up sshfs link...
        		sshfs -p 22 karenin:/disk/data/ /tmp/VFBproc3/ -o reconnect -C -o workaround=all
        		cd /tmp/VFBproc3/VFB/IMAGE_DATA/Janelia2012/TG/logs/

        		if [ $(ps x | grep warpToTemplate.py | wc -l) -gt 1 ]; then
            			echo Already on it.
        		else
            			echo Starting script...
                		nohup nice python ../script/DICE1warpToTemplate.py &
        		fi

		fi

	#else
	#	echo Problem! $exit_code
	#	hostname>>~/problem.txt
	#fi

fi


hostname>>~/machines.txt
echo Running....




