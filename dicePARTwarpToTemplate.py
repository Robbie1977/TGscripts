import os, re, shutil, subprocess, datetime, socket

cmtkdir = '/tmp/VFBproc/VFBTools/cmtk/bin/'

Tfile = '/tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/template/template_blue.nrrd'
outdir = '/tmp/VFBproc/VFB/IMAGE_DATA/Janelia2012/TG/logs/'

fo = open("FLwarp.txt",'r')

filelist = fo.readlines()

fo.close()

filelist = [f.replace('/disk/data/','/tmp/VFBproc/') for f in filelist]

hostn = socket.gethostname()

runid = os.getpid()

procid = '[' + hostn + ';' + str(runid) + ']'

print 'starting: %s' % (procid) 

for fname in filelist:
    fo = open("stop.txt",'r')
    stoplist = fo.readlines()
    if (hostn + '\n') in stoplist:
        print 'Stop requested!'
    else:  
        fname = fname.replace('\n','')  # .replace('./',outdir)
        try:
            if os.path.exists(fname):
                os.rename(fname,fname.replace('_blue',''))
                basename = fname.replace(outdir,'').replace('_blue.nrrd','')
                with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Started BG warp (part), ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                FloatFile = fname.replace('_blue','')
                Ixform = outdir + basename + '-initial.xform'
                Ioutput = outdir + basename + '-initial.nrrd'
                Axform = outdir + basename + '-affine.xform'
                Aoutput = outdir + basename + '-affine.nrrd'
                W5xform = outdir + basename + '-fastwarp.xform'
                W5output = outdir + basename + '-fastwarp.nrrd'
                print 'Warping file %s...' % fname 
                #check for complete skip
                if os.path.exists(W5xform): 
                    print 'Warp5 output already exists - skipping.'
                else:   
                    #Generate the Initial Transform
                    if os.path.exists(Ixform):
                        print 'Initial xform already exists - skipping.'
                    else:
                        return_code = subprocess.call('nice ' + cmtkdir + 'make_initial_affine --principal-axes %s %s %s' % (Tfile, FloatFile, Ixform + '_part'), shell=True)
                        os.rename(Ixform + '_part', Ixform)
                        print 'make_initial_affine returned: %d' % return_code
                    #Generate the Affine Transform
                    if os.path.exists(Axform):
                        print 'Affine xform already exists - skipping.'
                    else:
                        return_code = subprocess.call('nice ' + cmtkdir + 'registration --initial %s --dofs 6,9 --auto-multi-levels 4 -o %s %s %s' % (Ixform, Axform + '_part', Tfile, FloatFile), shell=True)
                        os.rename(Axform + '_part', Axform)
                        print 'registration returned: %d' % return_code
                print 'Completed part warpimg for %s.' % basename
                if os.path.exists(Axform):    
                    os.rename(fname.replace('_blue',''), fname)
                    
                    print '%s back in cue.' % basename
        
                    with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                            myfile.write(basename + ', Done Partial BG warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
        
                else:
                    print 'Failed warpimg for %s.' % basename
                    os.rename(fname.replace('_blue',''),fname.replace('_blue','_blue_error'))
                    with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Failed BG warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
        except OSError as e:
            print 'Skiping file'            
            with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                myfile.write(basename + ', Error during BG warp: ' + e.strerror + ', ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
print '%s All Done.' % procid








