import os, re, shutil, subprocess, datetime, socket, fileinput, sys

def replaceAll(file,searchExp,replaceExp):
    for line in fileinput.input(file, inplace=1):
        if searchExp in line:
            line = line.replace(searchExp,replaceExp)
        sys.stdout.write(line)


cmd0 = subprocess.Popen('ls -d /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/*-MC', shell=True, stdout=subprocess.PIPE)
for files in cmd0.stdout:
    files = files.replace('\n','')
    basename=files.replace('.nrrd-MC','').replace('.xform-MC','').replace('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/','').replace('-fastwarp','.lsm').replace('-','/').replace('/fA01','-fA01')
    print '# Re-adding %s to cue' % basename
    replaceAll('FLpre.txt',basename+' -Done',basename)
    basename=basename.replace('/','-').replace('.lsm','')
    print 'mv %s* ./temp/' % basename 
print '# Done.'    



