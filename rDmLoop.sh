#!/bin/bash
#
rn=0
na=0
nr=0
ou=0
er=0
sm=$(date +%m) 
nm=$(date +%m) 
echo $sm $nm
while [ $nm == $sm ]
do
	nice ssh vulcan 'nice ~/recruitDICEmachines.sh'
	nice sleep 1m
	#nice ~/checkDICEmachines.sh && sleep 5m && ~/clearStrays.sh
	cd /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs
	nice python ../script/repairDropped.py
	# cd ~
	nice sleep 1m
	nm=$(date +%m)
	echo $(date)
done

