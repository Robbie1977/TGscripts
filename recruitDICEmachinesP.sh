#!/bin/bash
#
# Script to find all machines where nobody is
# logged onto right now, but can be ssh'ed into.
# Additional criteria for selecting a machine:
#  - Fedora 13, not Pentium CPU, more than 1 CPU (core)
#
# Author: Marco Elver <marco.elver AT gmail.com>
# Date: Mon Nov  8 21:47:55 GMT 2010

TXT_RES="\033[0m"
TXT_RED="\033[1;31m"
TXT_BOLD="\033[1m"

[[ -n "$1" ]] && rm -vi "$1"

rm ~/machinesP.txt

host -l inf.ed.ac.uk | grep '129\.215\.5[89]\.'| cut -d "." -f 1 | sort -u |
while read host ; do
	(
	if (( $(ssh -n -oConnectTimeout=1 -oStrictHostKeyChecking=yes -oPasswordAuthentication=no "$host" '
		[ `grep processor /proc/cpuinfo | wc -l` -ge 2 ] &&
		! grep -q "Pentium" /proc/cpuinfo &&
		w
		' 2> /dev/null | wc -l) == 2 )); then

		echo -e "${TXT_BOLD}$host is usable.${TXT_RES}"

		if [[ -n "$1" ]]; then
			echo "$host" >> "$1"
		fi

		
		echo recruiting $host...
		ssh -n $host '~/DICEconfP.sh && exit' &
		

	else
		echo -e "${TXT_RED}$host not usable!${TXT_RES}"
	fi
	) &
	sleep 1.1s
done

