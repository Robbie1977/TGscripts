#!/bin/bash
# SCRIPT:  preProcess.sh
# PURPOSE: Run generate nrrd and zip lsm files
cd /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/
../script/gzipOriginalLsmFiles.sh
cp FLpre.txt FLpreZf.txt
echo Generating NRRD files... 
xvfb-run /disk/data/VFBTools/Fiji/fiji-linux64 ../script/preProcessZfFile.ijm 
../script/gzipOriginalLsmFiles.sh
echo Done.




