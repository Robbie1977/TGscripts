import os, re, shutil, subprocess, datetime, socket

cmtkdir = '/disk/data/VFBTools/cmtk/bin/'

Tfile = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/template/template_blue.nrrd'
outdir = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/'

fo = open("FLwarp.txt",'r')

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
                os.rename(fname,fname.replace('_blue',''))
                basename = fname.replace(outdir,'').replace('_blue.nrrd','')
                with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Started BG warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                FloatFile = fname.replace('_blue','')
                Ixform = outdir + basename + '-initial.xform'
                Ioutput = outdir + basename + '-initial.nrrd'
                Axform = outdir + basename + '-affine.xform'
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
                    #Generate the Warped Transform
                    if os.path.exists(W5xform):
                        print 'Warp5 xform already exists - skipping.'
                    else:
                        return_code = subprocess.call('nice ' + cmtkdir + 'warp -o %s --grid-spacing 80 --exploration 30 --coarsest 4 --accuracy 0.2 --refine 4 --energy-weight 1e-1 --initial %s %s %s' % (W5xform + '_part', Axform, Tfile, FloatFile), shell=True) #coarsest adjusted from 8 to 4 as per greg sug.
                        os.rename(W5xform + '_part', W5xform)
                        print 'warp (5) returned: %d' % return_code
                #Output a file to show the Warped Transform
                if os.path.exists(W5output):
                    print 'Warp5 output already exists - skipping.'
                else:
                    return_code = subprocess.call('nice ' + cmtkdir + 'reformatx -o %s --floating %s %s %s' % (W5output, FloatFile, Tfile, W5xform), shell=True)
                    print 'reformatx returned: %d' % return_code
                print 'Completed warpimg for %s.' % basename
                if os.path.exists(W5output):    
                    #os.remove(fname.replace('_blue',''))
                    shutil.move(fname.replace('_blue',''),fname.replace('logs/','logs/nrrds/'))
                    os.remove(Ixform)
                    #os.remove(Ioutput) Add if used
                    shutil.rmtree(Axform, ignore_errors=True)
                    #os.remove(Aoutput)
                    #os.remove(W5xform) #Needed for Signal Channel Warp
    
                    with open("FLsigWarp.txt", "a") as myfile:
                        myfile.write(W5xform + '\n')
    
                    #os.remove(W5output) #Needed for checking only
    
                    print 'Clean-up for %s done.' % basename

                    with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Finished BG warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')

                else:
                    print 'Failed warpimg for %s.' % basename
                    os.rename(fname.replace('_blue',''),fname.replace('_blue','_blue_error'))
                    with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Failed BG warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
        except OSError as e:
            print 'Skiping file'            
            with open("Warp.log", "a") as myfile: # Log entry for process time and error checking
                myfile.write(basename + ', Error during BG warp: ' + e.strerror + ', ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
print 'All Done.'








