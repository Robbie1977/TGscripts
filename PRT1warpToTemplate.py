import os, shutil, subprocess, datetime, socket, fnmatch, tarfile, time

from mysettings import ba, cmtkdir, fiji, Rawconv, Tfile, TfileR, ver, Qual

outdir = os.getcwd() + '/'

#fo = open("PLpre.txt",'r')

#filelist = fo.readlines()

#fo.close()

hostn = socket.gethostname()

runid = os.getpid()

procid = '[' + hostn + ';' + str(runid) + ']'

#for fname in filelist:

while not hostn in open('stop.txt').read():

    for fname in os.listdir('intray'):

        if fnmatch.fnmatch(fname, '*.lsm') or fnmatch.fnmatch(fname, '*.raw') or fnmatch.fnmatch(fname, '*.tif'):
                    
            fname = fname.replace('\n','').replace('/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/',outdir)
            Pcode = ''
            try:
                if os.path.exists('intray/' + fname):
                    os.rename('intray/' + fname,fname)
                    Pcode += 'R'
                    basename = fname
                    with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                        myfile.write(basename + ', Started PRT1 warp (' + ver + '), ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                    FloatFile = fname
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
                        Pcode += 'C'
                    else: 
                        #Generate the Initial Transform
                        Pcode += 'P'
                        if os.path.exists(Foutput):
                            print 'Global alignment already exists - skipping.'
                            Pcode += 'S'
                        else:
                            return_code = subprocess.call('nice ' + ba + ' -t %s -s %s -o %s -w 0 -C 0 -c 1 -B 1024 -Y' % (TfileR, FloatFile, Goutput), shell=True) # -F %s , GxDF
                            print 'Brain Aligner Global alignment returned: %d' % return_code
                            Pcode += 'B'
                            #Convert raw to nrrd
                            return_code = subprocess.call('nice ' + fiji + ' -macro %s %s -batch' % (Rawconv, Goutput), shell=True)
                            print 'Fiji/ImageJ conversion returned: %d' % return_code
                            Pcode += 'F'
                        #Generate the Affine Transform    
#                        if os.path.exists(Axform):
#                            print 'Affine xform already exists - skipping.'
#                            Pcode += 'S'
#                        else:
#                            FloatFile = Foutput
#                            return_code = subprocess.call('nice ' + cmtkdir + 'registration --dofs 6,9 --auto-multi-levels 4 -o %s %s %s' % (Axform + '_part', Tfile, FloatFile), shell=True)
#                            os.rename(Axform + '_part', Axform)
#                            print 'registration returned: %d' % return_code
#                            Pcode += 'A'
#                        #Generate the Warped Transform
#                        if os.path.exists(W5xform):
#                            print 'Warp5 xform already exists - skipping.'
#                            Pcode += 'S'
#                        else:
#                            return_code = subprocess.call('nice ' + cmtkdir + 'warp -o %s --grid-spacing 80 --exploration 30 --coarsest 4 --accuracy 0.2 --refine 4 --energy-weight 1e-1 --initial %s %s %s' % (W5xform + '_part', Axform, Tfile, FloatFile), shell=True) #coarsest adjusted from 8 to 4 as per greg sug.
#                            os.rename(W5xform + '_part', W5xform)
#                            print 'warp (5) returned: %d' % return_code
#                            Pcode += 'W'
#                    #Output a file to show the Warped Transform
#                    if os.path.exists(W5output):
#                        print 'Warp5 output already exists - skipping.'
#                        Pcode += 'S'
#                    else:
#                        return_code = subprocess.call('nice ' + cmtkdir + 'reformatx -o %s --floating %s %s %s' % (W5output, FloatFile, Tfile, W5xform), shell=True)
#                        print 'reformatx returned: %d' % return_code
#                        Pcode += 'R'
#                    print 'Completed background warpimg for %s.' % basename
#                    
#                    if os.path.exists(Routput + '_qual.csv'):
#                        print 'Quality measure already exists - skipping.'
#                        Pcode += 'S'
#                    else:
#                        return_code = subprocess.call('nice python %s %s %s %s_qual.csv &' % (Qual, W5output, Tfile, Routput), shell=True)
#                        print 'Qual returned: %d' % return_code
#                        Pcode += 'Q'
#                    print 'Completed generating Qual measure for %s.' % basename
            
                    
#                    if os.path.exists(Wsigout):
#                        print 'Signal warp output already exists - skipping.'
#                        Pcode += 'S'
#                    else:
#                        return_code = subprocess.call('nice ' + cmtkdir + 'reformatx -o %s --floating %s %s %s' % (Wsigout, SigFile, Tfile, W5xform), shell=True)
#                        print 'reformatx returned: %d' % return_code
#                        Pcode += 'D'
#                    print 'Completed signal warpimg for %s.' % basename
                    
    #                if os.path.exists(Routput):
    #                    print 'RAW warp output already exists - skipping.'
    #                else:
    #                    return_code = subprocess.call('nice ' + fiji + ' -macro %s %s -batch' % (Nrrdconv, Routput), shell=True)
    #                    print 'Fiji returned: %d' % return_code
    #                print 'Completed generating RAW warp for %s.' % basename
                                
                
                    
                    if os.path.exists(Foutput): #Routput
                        Pcode += 'F' 
                        #os.rename(fname,fname.replace('.lsm','-Done.lsm').replace('.raw','-Dome.raw').replace('.tif','-Done.tif'))   
                        
                        #shutil.move(fname.replace('_blue',''),fname.replace('logs/','logs/nrrds/'))
                        os.remove(Goutput)
                        #os.remove(Ioutput) Add if used
                        #shutil.rmtree(Axform, ignore_errors=True)
                        #os.remove(Aoutput)
                        
                        #compress final xform directory and remove original:  
                        #tar = tarfile.open(W5xform + '.tar.gz', 'w:gz')
                        #tar.add(W5xform)
                        #tar.close()
                        
                        #shutil.rmtree(W5xform, ignore_errors=True) 
                        #os.remove(fname)
                        #Pcode += 'C'
                        #with open("PLdone.txt", "a") as myfile:
                        #    myfile.write(Routput + '\n')
        
                        #os.rename(Wsigout,Wsigout.replace(outdir,outdir + 'outtray/'))
                        #os.rename(W5output,W5output.replace(outdir,outdir + 'outtray/'))
                        #os.rename(W5xform + '.tar.gz',W5xform.replace(outdir,outdir + 'outtray/') + '.tar.gz')
                        #os.rename(Routput + '_qual.csv',Routput.replace(outdir,outdir + 'outtray/') + '_qual.csv')
                        Pcode += 'M'
                        os.rename(fname,'intray/' + fname) # prep for PRT2
                        #os.remove(W5output) #Needed for checking only
                        
                        print 'Clean-up for %s done.' % basename
    
                        with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                            myfile.write(basename + ', Finished PRT1 warp (' + Pcode + '), ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
    
                    else:
                        print 'Failed warpimg for %s.' % basename
                        os.rename(fname,'intray/' + fname)
                        with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                            myfile.write(basename + ', Failed PRT1 warp (' + Pcode + '), ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
            except OSError as e:
                print 'Skiping file'            
                with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
                    myfile.write(basename + ', Error during PRT1 warp (' + Pcode + '): ' + e.strerror + ', ' + procid + ', ' + str(datetime.datetime.now()) + '\n')
                    try:
                        os.rename(fname,'intray/' + fname)
                    except:
                        print 'Not started!'
                        
    print 'All Done...'
    time.sleep(300) # sleep for 5 mins

print 'Stop requested!'
with open("PLwarp.log", "a") as myfile: # Log entry for process time and error checking
    myfile.write('Stoped by request!, ' + procid + ', ' + str(datetime.datetime.now()) + '\n')






