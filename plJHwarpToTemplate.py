import os, re, shutil, subprocess, datetime, socket

ba = '/groups/sciserv/flyolympiad/vnc_align/toolkit/JBA/brainaligner'

cmtkdir = '/usr/local/cmtk/bin/'

fiji = '/usr/local/Fiji/ImageJ-linux64'

Rawconv = '~/script/raw2nrrdCrop.ijm'
Nrrdconv = '~/script/nrrd2rawUncrop.ijm'

Tfile = '~/template/flyVNCtemplate20xDaC.nrrd'
TfileR = '~/template/flyVNCtemplate20xDa.raw'
TfileM = '~/template/flyVNCtemplate20xDa.marker'

Qual = '~/script/Quality.py'

outdir = os.getcwd() + '/'

fo = open("PLwarp.txt",'r')

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
        fname = fname.replace('\n','').replace('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/',outdir)
        try:
            if os.path.exists(fname):
                os.rename(fname,fname.replace('.lsm','~.lsm').replace('.raw','~.raw'))
                basename = fname.replace(outdir,'').replace('.lsm','').replace('20130404_s/','').replace('.raw','').replace('Rigid/','').replace('/groups/sciserv/flyolympiad/vnc_align/20130404_lsms/','')
                with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Started JH warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                FloatFile = fname.replace('.lsm','~.lsm').replace('.raw','~.raw')
                GxDF = outdir + basename + '-global.raw'
                Goutput = basename + '-rigid.raw'
                Axform = outdir + basename + '-rigid-affine.xform'
                Foutput = Goutput.replace('-rigid.raw', '-rigid_C2.nrrd')
                SigFile = Goutput.replace('-rigid.raw', '-rigid_C1.nrrd')
                W5xform = outdir + basename + '-rigid-fastwarp.xform'
                W5output = outdir + basename + '-rigid-BGwarp.nrrd'
                Wsigout = outdir + basename + '-rigid-SGwarp.nrrd'
                Routput = basename + '-rigid-warp.raw'
                Loutput = basename + '-rigid-warp-local'
                print 'Warping file %s...' % fname 
                #check for complete skip
                if os.path.exists(W5xform): 
                    print 'Warp5 output already exists - skipping.'
                else: 
                    #Generate the Initial Transform
                    if os.path.exists(Goutput):
                        print 'Global alignment already exists - skipping.'
                    else:
                        return_code = subprocess.call('nice ' + ba + ' -t %s -s %s -o %s -F %s -w 0 -C 0 -c 1 -B 1024 -Y' % (TfileR, FloatFile, Goutput, GxDF), shell=True)
                        print 'Brain Aligner Global alignment returned: %d' % return_code
                        #Convert raw to nrrd
                        return_code = subprocess.call('nice xvfb-run ' + fiji + ' -macro %s %s' % (Rawconv, Goutput), shell=True)
                        print 'Fiji/ImageJ conversion returned: %d' % return_code
                    #Generate the Affine Transform    
                    if os.path.exists(Axform):
                        print 'Affine xform already exists - skipping.'
                    else:
                        FloatFile = Foutput
                        return_code = subprocess.call('nice ' + cmtkdir + 'registration --dofs 6,9 --auto-multi-levels 4 --match-histograms -o %s %s %s' % (Axform + '_part', Tfile, FloatFile), shell=True)
                        os.rename(Axform + '_part', Axform)
                        print 'registration returned: %d' % return_code
                    #Generate the Warped Transform
                    if os.path.exists(W5xform):
                        print 'Warp5 xform already exists - skipping.'
                    else:
                        return_code = subprocess.call('nice ' + cmtkdir + 'warp -o %s --grid-spacing 80 --exploration 30 --coarsest 4 --match-histograms --accuracy 0.2 --refine 4 --energy-weight 1e-1 --initial %s %s %s' % (W5xform + '_part', Axform, Tfile, FloatFile), shell=True) #coarsest adjusted from 8 to 4 as per greg sug.
                        os.rename(W5xform + '_part', W5xform)
                        print 'warp (5) returned: %d' % return_code
                #Output a file to show the Warped Transform
                if os.path.exists(W5output):
                    print 'Warp5 output already exists - skipping.'
                else:
                    return_code = subprocess.call('nice ' + cmtkdir + 'reformatx -o %s --floating %s %s %s' % (W5output, FloatFile, Tfile, W5xform), shell=True)
                    print 'reformatx returned: %d' % return_code
                print 'Completed background warpimg for %s.' % basename
                if os.path.exists(Wsigout):
                    print 'Signal warp output already exists - skipping.'
                else:
                    return_code = subprocess.call('nice ' + cmtkdir + 'reformatx -o %s --floating %s %s %s' % (Wsigout, SigFile, Tfile, W5xform), shell=True)
                    print 'reformatx returned: %d' % return_code
                print 'Completed signal warpimg for %s.' % basename
                
                if os.path.exists(Routput):
                    print 'RAW warp output already exists - skipping.'
                else:
                    return_code = subprocess.call('nice xvfb-run ' + fiji + ' -macro %s %s' % (Nrrdconv, Routput), shell=True)
                    print 'Fiji returned: %d' % return_code
                print 'Completed generating RAW warp for %s.' % basename
                
#                if os.path.exists(Loutput + '.raw'):
#                    print 'Brianaligner local output already exists - skipping.'
#                else:
#                    return_code = subprocess.call('nice ' + ba + ' -t %s -s %s -L %s -o %s -w 10 -C 0 -c 0 -H 2 -B 1024' % (TfileR, Routput, TfileM, Loutput + '.raw'), shell=True) #  
#                    print 'Brainaligner returned: %d' % return_code
#                print 'Completed generating RAW warp for %s.' % basename
                
                if os.path.exists(Routput + '_qual.csv'):
                    print 'Quality measure already exists - skipping.'
                else:
                    return_code = subprocess.call('nice python %s %s %s %s_qual.csv' % (Qual, W5output, Tfile, Routput), shell=True)
                    print 'Qual returned: %d' % return_code
                print 'Completed generating Qual measure for %s.' % basename
                
                
                if os.path.exists(W5output):    
                    #os.remove(fname.replace('_blue',''))
                    #shutil.move(fname.replace('_blue',''),fname.replace('logs/','logs/nrrds/'))
                    #os.remove(Goutput)
                    #os.remove(Ioutput) Add if used
                    #shutil.rmtree(Axform, ignore_errors=True)
                    #os.remove(Aoutput)
                    #os.remove(W5xform) #Needed for Signal Channel Warp
    
                    with open("PLdone.txt", "a") as myfile:
                        myfile.write(Routput + '\n')
    
                    #os.remove(W5output) #Needed for checking only
    
                    print 'Clean-up for %s done.' % basename

                    with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Finished JH warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')

                else:
                    print 'Failed warpimg for %s.' % basename
                    os.rename(fname.replace('_blue',''),fname.replace('_blue','_blue_error'))
                    with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Failed JH warp, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
        except OSError as e:
            print 'Skiping file'            
            with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                myfile.write(basename + ', Error during JH warp: ' + e.strerror + ', ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
print 'All Done.'








