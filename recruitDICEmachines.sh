#!/bin/bash
#
# Script to find all machines where nobody is
# logged onto right now, but can be ssh'ed into.
# Additional criteria for selecting a machine:
#  - Fedora 13, not Pentium CPU, more than 1 CPU (core)
#
# Author: Marco Elver <marco.elver AT gmail.com>
# Date: Mon Nov  8 21:47:55 GMT 2010

TXT_RES=$'\e[0;m'
TXT_RED=$'\e[1;31m'
TXT_GRN=$'\e[1;32m'
TXT_YLW=$'\e[1;33m'
TXT_BOLD=$'\e[1m'
RN=0; export RN
NA=0; export NA
NR=0; export NR
OU=0; export OU
ER=0; export ER

[[ -n "$1" ]] && rm -vi "$1"

rm -f ~/machines.txt
rm -f ~/offline.txt

host -l inf.ed.ac.uk | grep '129\.215\.5[89]\.'| cut -d "." -f 1 | sort -u |
while read host ; do
  if [ `tail -n 500 /tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/Warp.log | grep "$host" | wc -l` -gt 0 ]; then
		exit_code=45
  else	
	ssh -n -oConnectTimeout=1 -oStrictHostKeyChecking=yes -oPasswordAuthentication=no "$host" '
if [ `grep processor /proc/cpuinfo | wc -l` -ge 2 ] && \
  ! grep -q "Pentium" /proc/cpuinfo && [ `pgrep -u s1002628 python | wc -l` -lt 1 ] && [ "$(w -h | wc -l)" == 0 ]; then
	echo recruiting $(hostname)...
	nohup ~/DICEconf.sh &>>~/remote.txt &
	sleep 20s
	if [ `pgrep -u s1002628 -f warpToTemplate | wc -l` -gt 1 ]; then
		exit 0
	else
		exit 43
	fi
else
	if [ `pgrep -u s1002628 -f warpToTemplate | wc -l` -gt 1 ]; then
               	exit 44
        else
                exit 42
        fi
fi' 2> /dev/null

	exit_code=$?

  fi

	#echo $(date), $rn, $nr, $er, $ou, $na

	if (( exit_code == 0 )); then
		echo "${TXT_BOLD}$host recruited.${TXT_RES}"

		#ssh $host 'nohup ~/DICEconf.sh `</dev/null` >>nohup.out 2>&1 &' &
		#ssh -o ConnectTimeout=10 ${host} ${CMD}
		let NR=NR+1; #export NR
	elif (( exit_code == 42 )); then
		echo "${TXT_YLW}$host is not available.${TXT_RES}"
		let OU=OU+1; #export OU
	elif (( exit_code == 43 )); then
		echo "${TXT_BOLD}$host NOT recruted!${TXT_RES}"
		let ER=ER+1; #export ER
	elif (( exit_code == 44 )); then
                echo "${TXT_GRN}$host already running...${TXT_RES}"
		let RN=RN+1; #export RN
	elif (( exit_code == 45 )); then
                echo "${TXT_YLW}$host already running..${TXT_RES}"
                let RN=RN+1; #export RN
	else
		echo "${TXT_RED}$host is not reachable.${TXT_RES}"
		let NA=NA+1; #export NA
		echo $host >> offline.txt
	fi
	if [ $host == 'zuniga' ]; then
		echo $(date), $RN, $NR, $ER, $OU, $NA
		echo $(date), $RN, $NR, $ER, $OU, $NA >> /tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/Recruit.log
	fi
        #sleep 1.1s

done

#echo $(date), $RN, $NR, $ER, $OU, $NA
#echo $(date), $RN, $NR, $ER, $OU, $NA >> Recruit.log

