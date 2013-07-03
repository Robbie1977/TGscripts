#!/bin/bash
# SCRIPT:  postProcess.sh
# PURPOSE: Run signal warp and generate and sort woolz files
cd /tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/
echo Checking for size errors...
# ../script/fastwarpTest.sh
while [ `ls *fastwarp.nrrd | wc -l` -gt 0 ]
do
    echo Warping Signal... 
    python ../script/warpSignalToTemplate.py
    xvfb-run /disk/data/VFBTools/Fiji/fiji-linux64 ../script/nrrd2tiffs.ijm 
    ../script/createWoolz.sh
    ../script/createMetaData.sh
    ../script/sortStacks.sh

    echo Done.
done
echo Finished all!



