import os, re, shutil, subprocess, datetime, socket

cmd0 = subprocess.Popen('ls /disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/*[0-9].nrrd', shell=True, stdout=subprocess.PIPE)

with open("/afs/inf.ed.ac.uk/user/s10/s1002628/offline.txt", "r") as myfile:
    global offline, count
    count=0
    offline=''
    for line in myfile:
        offline=offline + line.replace('\n','.inf.ed.ac.uk, ') 
print 'Currently offline: %s' % offline.replace('.inf.ed.ac.uk,',',')

for files in cmd0.stdout:
    global first, last, dt, procID
    files = files.replace('\n','')
    basename=files.replace('.nrrd','').replace('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/','')
    #print 'checking %s' % basename
    fo = open('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/Warp.log','r')
    filelist = fo.readlines()
    fo.close()
    for line in filelist:
        line = line.replace('\n','')
        if basename in line and 'Started BG' in line:
            global first
            first = line
    procID=first.split(', ')[2].split(';')[0] 
    dt=first.split(', ')[3]        
    #print 'Started on %s] %s' % (procID, dt)  
    for line in filelist:
        global last
        line = line.replace('\n','')
        if procID in line and 'Started BG' in line:
            last = line
    if first in last:
        if not procID.replace('[','') in offline:
            print '%s still outstanding from %s %s]' % (basename, dt, procID)
            count=count + 1
        else:
            print '!!! %s appears to have been dropped by unresponsive %s] re-adding to stack... !!!' % (basename, procID) 
            if os.path.exists('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/' + basename + '_blue.nrrd'):
                os.remove(files)    
            else:
                os.rename(files, '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/' + basename + '_blue.nrrd')                 
    else:
        try:
            if 'charlotte' in procID:
                print '--Exception for charlotte also doing part runs--'
                print '%s still outstanding from %s %s]' % (basename, dt, procID)
            else:
                print '!!! %s has been dropped by %s] re-adding to stack... !!!' % (basename, procID) 
                if os.path.exists('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/' + basename + '_blue.nrrd'):
                    os.remove(files)    
                else:
                    os.rename(files, '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/' + basename + '_blue.nrrd')
        except OSError as e:
            print 'error renaming file: %s' % e.strerror
print '%s still running.' % count
                   

