import os, re, shutil, subprocess, datetime, socket

cmd0 = subprocess.Popen('ls /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/*d-MC', shell=True, stdout=subprocess.PIPE)
for files in cmd0.stdout:
    basename=files.replace('-fastwarp.nrrd-MC','').replace('\n','').replace('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/','')
    print 'Processing %s...' % basename
    with open("MCclean.txt", "a") as myfile:
        myfile.write('mv'+ ' ' + basename + '* ./temp/' + '\n')
        myfile.write('mv ./temp/' + basename + '_blue.nrrd ./' + '\n')
        myfile.write('mv ./temp/' + basename + '_green.nrrd ./' + '\n')
print 'Done.'
