#!/bin/bash
# SCRIPT:  DICEconf.sh
# PURPOSE: configure and run CwarpToTemplate.py on DICE machines
hn=$(hostname)

if [ ! -d /tmp/130617 ]; 
then
	echo Setting up directories... 
	mkdir /tmp/130617
	sshfs -p 22 karenin:/disk/data/ /tmp/130617/ -o reconnect -C -o workaround=all
	sleep 2
fi
sleep 0.5s
if [ ! -d /tmp/130617/VFBTools ]; 
then
	echo Setting up sshfs link...
        sshfs -p 22 karenin:/disk/data/ /tmp/130617/ -o reconnect -C -o workaround=all
	sleep 2s
fi
echo Starting script...
cd /tmp/130617/VFB/IMAGE_DATA/Janelia2012/TG/logs/
nosleep nohup nice python ../script/CwarpToTemplate.py > ${hn}.log &
	
rp=$( ps x | grep warpToTemplate | wc -l )
hn=$( hostname )
pc=$( cat /proc/cpuinfo | grep processor | wc -l )
echo $hn'('$pc') - '$rp>>machines.txt

if [ "$(pgrep python)" ]
then
	echo Running....
else
	echo Failed!!!
	pgrep sshfs | xargs kill 
fi




