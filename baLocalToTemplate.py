import os, re, shutil, subprocess, datetime, socket

badir = '../../../../../VFBTools/brainaligner/brainaligner'

Tfile = '../template/flyVNCtemplate2.raw'
Lfile = '../template/flyVNCtemplate2_qul.marker'

outdir = './'

fo = open("FLrigidF.txt",'r')

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
                os.rename(fname,fname.replace('rigid.raw','rigid-l.raw'))
                basename = fname.replace(outdir,'').replace('.raw','')
                with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Started BA local trans, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                FloatFile = fname.replace('rigid.raw','rigid-l.raw')
                Lxoutput = outdir + basename + '-local_m2q.raw'
                print 'Warping file %s...' % fname 
                #check for complete skip
                if os.path.exists(Lxoutput):
                    print 'Local output already exists - skipping.'
                else: 
                    return_code = subprocess.call('nice ' + badir + ' -t %s -s %s -L %s -o %s -w 10 -C 0 -c 0 -H 2 -B 1024' % (Tfile, FloatFile, Lfile, Lxoutput), shell=True)
                    print 'local alignment returned: %d' % return_code
                if os.path.exists(Lxoutput):
                    
                    with open("FLbrainL.txt", "a") as myfile:
                        myfile.write(Lxoutput + '\n')
    
                    with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Finished BA local trans, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')

                else:
                    print 'Failed local for %s.' % basename
                    with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Failed BA local trans, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
        except OSError as e:
            print 'Skiping file'            
            with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                myfile.write(basename + ', Error during BA local trans: ' + e.strerror + ', ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
print 'All Done.'








