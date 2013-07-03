import os, re, shutil, subprocess, datetime, socket

badir = '/disk/data/VFBTools/brainaligner/brainaligner'

Tfile = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/template/flyVNCtemplate2.raw'
Lfile = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/template/flyVNCtemplate7.marker'

outdir = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/'

fo = open("FLlocal.txt",'r')

filelist = fo.readlines()

fo.close()

hostn = socket.gethostname()

runid = os.getpid()

procid = '[' + hostn + ';' + str(runid) + ']'

for fname in filelist:

    fo = open("stop.txt",'r')
    stoplist = fo.readlines()
    if (hostn + '\n') in stoplist:
        print 'Stop requested!'
    else:  
        fname = fname.replace('\n','')  # .replace('./',outdir)
        try:
            if os.path.exists(fname):
                os.rename(fname,fname.replace('affine.tif','affine-l.tif'))
                basename = fname.replace(outdir,'').replace('.tif','')
                with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Started BG local trans, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                FloatFile = fname.replace('affine.tif','affine-l.tif')
                Lxoutput = outdir + basename + '-local.raw'
                print 'Warping file %s...' % fname 
                #check for complete skip
                if os.path.exists(Lxoutput):
                    print 'Affine output already exists - skipping.'
                else: 
                    return_code = subprocess.call('nice ' + badir + ' -t %s -s %s -L %s -o %s -w 10 -C 0 -c 0 -H 2 -B 1024' % (Tfile, FloatFile, Lfile, Lxoutput), shell=True)
                    print 'local alignment returned: %d' % return_code
                if os.path.exists(Axoutput):
                    
                    with open("FLbrainL.txt", "a") as myfile:
                        myfile.write(Lxoutput + '\n')
    
                    #os.remove(W5output) #Needed for checking only
    
                    print 'Clean-up for %s done.' % basename

                    with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Finished BG local trans, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')

                else:
                    print 'Failed affine for %s.' % basename
                    with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Failed BG local trans, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
        except OSError as e:
            print 'Skiping file'            
            with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                myfile.write(basename + ', Error during BG local trans: ' + e.strerror + ', ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
print 'All Done.'








