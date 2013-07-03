import os, re, shutil, subprocess, datetime, socket
print '-------------------------------------------------------------------------'
cmd0 = subprocess.Popen('ls /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/*_blue.nrrd', shell=True, stdout=subprocess.PIPE)
for files in cmd0.stdout:
    files = files.replace('\n','')
    basename=files.replace('_blue','_green')
    if not os.path.exists(basename):
        print basename
print '-------------------------------------------------------------------------'
cmd0 = subprocess.Popen('ls /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/*warp.nrrd', shell=True, stdout=subprocess.PIPE)
for files in cmd0.stdout:
    files = files.replace('\n','')
    basename=files.replace('-fastwarp','-warpedSig')
    if not os.path.exists(basename):
        #print basename
        print 'rm %s' % files 
    basename=files.replace('-fastwarp','_blue')
    #if not os.path.exists(basename):
        #print basename
print '-------------------------------------------------------------------------'
