#!/bin/bash
# SCRIPT:  sortStacks.sh
# PURPOSE: Sorts files into subfolders

. /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/script/initVars.bsh


for f in $stacksDir*
do
  echo "Processing $f file..."
  newFolder=${f//"-"/"/"}
  newFolder=${newFolder/"/fA"/"-fA"} #correct last split
  if [ ${f:(-3)} == "wlz" ]
  then
    fileTree=${newFolder%/GMR*.wlz}
    echo $fileTree
    mkdir -p $fileTree/wlz/
    echo WLZ mv $f $fileTree/wlz/${newFolder:(-6)}
    mv $f $fileTree/wlz/${newFolder:(-6)}
  elif [ ${f:(-3)} == "jso" ]
  then
    fileTree=${newFolder%.*o}
    echo $fileTree
    mkdir -p $fileTree/wlz_meta/
    echo JSO mv $f $fileTree/wlz_meta/tiledImageModelData.jso
    mv $f $fileTree/wlz_meta/tiledImageModelData.jso
  elif [ ${f:(-3)} == "gif" ]
  then
    echo GIF mv $f $newFolder/flylight/$file1$file2/LSMthumb.gif
    fileTree="/"${newFolder##"/"*"/"}"/"
    newFolder=${newFolder%"/"*gif}
    file1=${fileTree#"/"*"_"}
    if [ ${#file1} -gt 15 ]
    then
        file1=${file1:0:2}
    else
        file1=${file1:0:1}
    fi
    file2=${fileTree%.gi*}
    mkdir -p $newFolder/flylight/$file1$file2/
    mv $f $newFolder/flylight/$file1$file2/LSMthumb.gif
  else
    echo unknown file type: $f
  fi 
done

