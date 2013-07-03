import os, shutil, subprocess, datetime, socket, fnmatch, tarfile, time

from mysettings import cmtkdir, fiji, Tfile, ver, Qual, LsmPP

outdir = os.getcwd() + '/'

#fo = open("PLpre.txt",'r')

#filelist = fo.readlines()

#fo.close()



hostn = socket.gethostname()

runid = os.getpid()

procid = '[' + hostn + ';' + str(runid) + ']'

#for fname in filelist:

while not hostn in open('stop.txt', 'rb').read():

    for fname in os.listdir('intray'):

        if fnmatch.fnmatch(fname, '*.lsm') or fnmatch.fnmatch(fname, '*.raw') or fnmatch.fnmatch(fname, '*.tif'):
                    
            fname = fname.replace('\n','').replace('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/',outdir)
            Pcode = ''
            try:
                if os.path.exists('intray/' + fname):
                    os.rename('intray/' + fname,fname)
                    Pcode += 'R'
                    basename = fname.replace('.lsm','')
                    with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Started JH warp (' + ver + '), ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                    FloatFile = fname
                    GxDF = outdir + basename + '-global.raw'
                    Goutput = basename + '-PP_C2.nrrd'
                    Ixform = outdir + basename + '-PP-initial.xform'
                    Axform = outdir + basename + '-PP-affine.xform'
                    Foutput = Goutput.replace('-PP.raw', '-PP_C2.nrrd')
                    SigFile = Goutput.replace('-PP.raw', '-PP_C1.nrrd')
                    MetFile = Goutput.replace('-PP.raw', '-PP_Meta.log')
                    W5xform = outdir + basename + '-PP-warp.xform'
                    W5output = outdir + basename + '-PP-BGwarp.nrrd'
                    Wsigout = outdir + basename + '-PP-SGwarp.nrrd'
                    Routput = basename + '-PP-BGwarp.nrrd'
                    Qualout = basename + '-PP-warp.raw_qual.csv'
                    Loutput = basename + '-PP-warp-local'
                    print 'Warping file %s...' % fname 
                    #check for complete skip
                    if os.path.exists(W5xform): 
                        print 'Warp5 output already exists - skipping.'
                        Pcode += 'C'
                    else: 
                        #Generate the Initial preprocessing
                        Pcode += 'P'
                        if os.path.exists(Foutput):
                            print 'Preprocessing already done - skipping.'
                            Pcode += 'S'
                        else:
                            return_code = subprocess.call('nice xvfb-run ' + fiji + ' -macro %s ./%s -batch' % (LsmPP, FloatFile), shell=True) # -F %s , GxDF
                            print 'Preprocessing returned: %d' % return_code
                            Pcode += 'pp'
                            #Convert raw to nrrd
                            #return_code = subprocess.call('nice ' + fiji + ' -macro %s %s -batch' % (Rawconv, Goutput), shell=True)
                            #print 'Fiji/ImageJ conversion returned: %d' % return_code
                            #Pcode += 'F'
                        #Generate the Initial Transform   
                        if os.path.exists(Ixform):
                            print 'Initial xform already exists - skipping.'
                            Pcode += 'S'
                            FloatFile = Foutput
                        else:
                            FloatFile = Foutput
                            return_code = subprocess.call('nice ' + cmtkdir + 'make_initial_affine --principal-axes %s %s %s' % (Tfile, FloatFile, Ixform + '_part'), shell=True)
                            os.rename(Ixform + '_part', Ixform)
                            print 'Initial registration returned: %d' % return_code
                            Pcode += 'I' 
                        if os.path.exists(Axform):
                            print 'Affine xform already exists - skipping.'
                            Pcode += 'S'
                        else:
                            return_code = subprocess.call('nice ' + cmtkdir + 'registration --initial %s --dofs 6,9 --auto-multi-levels 4 -o %s %s %s' % (Ixform, Axform + '_part', Tfile, FloatFile), shell=True)
                            os.rename(Axform + '_part', Axform)
                            print 'registration returned: %d' % return_code
                            Pcode += 'A'
                        #Generate the Warped Transform
                        if os.path.exists(W5xform):
                            print 'Warp5 xform already exists - skipping.'
                            Pcode += 'S'
                        else:
                            return_code = subprocess.call('nice ' + cmtkdir + 'warp -o %s --grid-spacing 80 --exploration 30 --coarsest 4 --accuracy 0.2 --refine 4 --energy-weight 1e-1 --initial %s %s %s' % (W5xform + '_part', Axform, Tfile, FloatFile), shell=True) #coarsest adjusted from 8 to 4 as per greg sug.
                            os.rename(W5xform + '_part', W5xform)
                            print 'warp (5) returned: %d' % return_code
                            Pcode += 'W'
                    #Output a file to show the Warped Transform
                    if os.path.exists(W5output):
                        print 'Warp5 output already exists - skipping.'
                        Pcode += 'S'
                    else:
                        return_code = subprocess.call('nice ' + cmtkdir + 'reformatx -o %s --floating %s %s %s' % (W5output, FloatFile, Tfile, W5xform), shell=True)
                        print 'reformatx returned: %d' % return_code
                        Pcode += 'R'
                    print 'Completed background warpimg for %s.' % basename
                    
                    if os.path.exists(Qualout):
                        print 'Quality measure already exists - skipping.'
                        Pcode += 'S'
                    else:
                        return_code = subprocess.call('nice python %s %s %s %s &' % (Qual, W5output, Tfile, Qualout), shell=True)
                        print 'Qual returned: %d' % return_code
                        Pcode += 'Q'
                    print 'Completed generating Qual measure for %s.' % basename
            
                    
                    if os.path.exists(Wsigout):
                        print 'Signal warp output already exists - skipping.'
                        Pcode += 'S'
                    else:
                        return_code = subprocess.call('nice ' + cmtkdir + 'reformatx -o %s --floating %s %s %s' % (Wsigout, SigFile, Tfile, W5xform), shell=True)
                        print 'reformatx returned: %d' % return_code
                        Pcode += 'D'
                    print 'Completed signal warpimg for %s.' % basename
                    
    #                if os.path.exists(Routput):
    #                    print 'RAW warp output already exists - skipping.'
    #                else:
    #                    return_code = subprocess.call('nice ' + fiji + ' -macro %s %s -batch' % (Nrrdconv, Routput), shell=True)
    #                    print 'Fiji returned: %d' % return_code
    #                print 'Completed generating RAW warp for %s.' % basename
                                
                
                    
                    if os.path.exists(W5output):
                        Pcode += 'F' 
                        #os.rename(fname,fname.replace('.lsm','-Done.lsm').replace('.raw','-Dome.raw').replace('.tif','-Done.tif'))   
                        
                        #shutil.move(fname.replace('_blue',''),fname.replace('logs/','logs/nrrds/'))
                        if os.path.exists(Foutput): 
				os.remove(Foutput)
                        if os.path.exists(SigFile): 
                                os.remove(SigFile)
                        if os.path.exists(Ixform): 
                                os.remove(Ixform) 
                        if os.path.exists(Axform): 
                                shutil.rmtree(Axform, ignore_errors=True)
                        #os.remove(Aoutput)
                        
                        if os.path.exists(W5xform): 
                                #compress final xform directory and remove original:  
                        	tar = tarfile.open(W5xform + '.tar.gz', 'w:gz')
                        	tar.add(W5xform)
                        	tar.close()
                        
                        	shutil.rmtree(W5xform, ignore_errors=True) 
                        if os.path.exists(fname): 
                                os.remove(fname)
                        Pcode += 'C'
                        with open("PLdone.txt", "a") as myfile:
                            myfile.write(Wsigout + '\n')
        
                        if os.path.exists(MetFile):
                                os.rename(MetFile,'outtray/' + MetFile)
                        if os.path.exists(Wsigout):
                                os.rename(Wsigout,Wsigout.replace(outdir,outdir + 'outtray/'))
                        if os.path.exists(W5output):
                                os.rename(W5output,W5output.replace(outdir,outdir + 'outtray/'))
                        if os.path.exists(W5xform + '.tar.gz'):
                                os.rename(W5xform + '.tar.gz',W5xform.replace(outdir,outdir + 'outtray/') + '.tar.gz')
                        if os.path.exists(Qualout):
                                os.rename(Qualout,'outtray/' + Qualout)
                        Pcode += 'M'
                
                        #os.remove(W5output) #Needed for checking only
                        
                        print 'Clean-up for %s done.' % basename
    
                        with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                            myfile.write(basename + ', Finished JH warp (' + Pcode + '), ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
    
                    else:
                        print 'Failed warpimg for %s.' % basename
                        os.rename(fname,'intray/' + fname)
                        with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                            myfile.write(basename + ', Failed JH warp (' + Pcode + '), ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
            except OSError as e:
                print 'Skiping file'            
                with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Error during JH warp (' + Pcode + '): ' + e.strerror + ' (' + str(e.filename) +'), ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                    try:
                        os.rename(fname,'intray/' + fname)
                    except:
                        print 'Not started!'
                        
    print 'All Done...'
    time.sleep(88) # sleep for 1.33 mins

print 'Stop requested!'
with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
    myfile.write('Stoped by request!, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')






