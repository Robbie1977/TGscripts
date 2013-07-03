#!/bin/bash
# SCRIPT:  fastwarpTest.sh
# PURPOSE: Detects and flags potentially badly warped stacks

for f in *-fastwarp.nrrd;
do
    S=$(stat --printf="%s" $f)
    if [ $S -lt 32000000 -o $S -gt 62000000 ];
    then
        mv $f $f-MC
        mv ${f%.nrrd}.xform ${f%.nrrd}.xform-MC
	mv ${f%-fastwarp.nrrd}-warpedSig.nrrd ${f%-fastwarp.nrrd}-warpedSig.nrrd-MC
        echo $f-MC >> MCfastwarp.txt     
    fi
    
done        
