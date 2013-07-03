import os, re, shutil, subprocess, datetime, socket

cmtkdir = '/disk/data/VFBTools/cmtk/bin/'

Tfile = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/template/template_blue.nrrd'
outdir = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/'

fo = open("FLsigWarp.txt",'r')

filelist = fo.readlines()

fo.close()


hostn = socket.gethostname()

runid = os.getpid()

procid = '[' + hostn + ';' + str(runid) + ']'

for fname in filelist:
    fname = fname.replace('\n','')
    print 'Trying %s' % fname        
    try:
        basename = fname.replace('-fastwarp.xform', '').replace(outdir,'')
        if (os.path.exists(fname) and os.path.exists(basename + '-fastwarp.nrrd')):
            with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                myfile.write(basename + ', Started Sig warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
            SignalFile = outdir + basename + '_green.nrrd'
            W5xform = fname
            W5output = outdir + basename + '-warpedSig.nrrd'
            print 'Warping file %s...' % fname
            if os.path.exists(W5output):
                print 'Warp5 output already exists - skipping.'
            else:
                return_code = subprocess.call('nice ' + cmtkdir + 'reformatx -o %s --floating %s %s %s' % (W5output, SignalFile, Tfile, W5xform), shell=True)
                print 'reformatx returned: %d' % return_code
            print 'Completed warpimg for %s.' % basename
            if os.path.exists(W5output):                 
                with open("FLwoolz.txt", "a") as myfile:
                    myfile.write(W5output + '\n')
                os.rename(SignalFile,SignalFile.replace('logs/','logs/nrrds/'))
                #os.remove(SignalFile) 
                #shutil.rmtree(fname, ignore_errors=True)
                
                print 'Clean-up for %s done.' % basename
                with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Finished Sig warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
            else:
                print 'Failed signal warpimg for %s.' % basename
                with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Failed Sig warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
        else:
            print 'Not Found...'

    except OSError as e:
        print 'Skiping file'
        with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
            myfile.write(basename + ', Error during Sig warp: ' + e.strerror + ', ' + procid + ', ' + str(datetime.datetime.now()) + '\n')

print 'All Done.'




