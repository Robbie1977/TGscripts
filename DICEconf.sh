#!/bin/bash
# SCRIPT:  DICEconf.sh
# PURPOSE: configure and run warpToTemplate.py on DICE machines
exit_code=0
if [ ! -d /tmp/VFBproc -a ! -d /tmp/VFBproc1 ]; 
then
	echo Setting up directories... 
	mkdir /tmp/VFBproc
	exit_code=$?
fi
sleep 0.5s
if [ exit_code == 0 ]; then

if [ ! -d /tmp/VFBproc/VFBTools -a ! -d /tmp/VFBproc1/VFBTools ]; 
then
	echo Setting up sshfs link...
        sshfs -p 22 karenin:/disk/data/ /tmp/VFBproc/ -o reconnect -C -o workaround=all
	sleep 2s

	echo Starting script...
	cd /tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/
        nohup python ../script/DICEwarpToTemplate.py &
	

else
    if [ $(ps x | grep warpToTemplate | grep py | wc -l) -gt 0 ];
	then
    		echo Already on it.
	else
    		if [ -d /tmp/VFBproc1/VFBTools ];
    		then
    		    echo Starting script...
		    cd /tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/
        	    nohup nice python ../script/DICE1warpToTemplate.py &
        	else
        	    echo Starting script...
                    cd /tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/
        	    nohup nice python ../script/DICEwarpToTemplate.py &
        	fi
	fi    
fi

else 
	~/DICE1conf.sh 
fi

rp=$( ps x | grep warpToTemplate | wc -l )
hn=$( hostname )
pc=$( cat /proc/cpuinfo | grep processor | wc -l )
echo $hn'('$pc') - '$rp>>~/machines.txt

echo Running....




