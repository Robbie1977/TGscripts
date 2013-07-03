#!/bin/bash
# SCRIPT:  preProcess.sh
# PURPOSE: Run generate nrrd and zip lsm files
cd /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/
#../script/gzipOriginalLsmFiles.sh
echo Generating NRRD files... 
xvfb-run /disk/data/VFBTools/Fiji/fiji-linux64 ../script/preProcessFile.ijm 
#../script/gzipOriginalLsmFiles.sh
echo Done.




