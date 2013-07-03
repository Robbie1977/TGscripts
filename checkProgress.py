import os, re, shutil, subprocess, fnmatch

filesdir = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/'
outdir = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/'

t=0
p=0
s=0
n=0
w=0

fo = open("FLpre.txt",'r')
filelist = fo.readlines()
for l in filelist:
    if "Done" in l:
        p=p+1
    t = t + 1
	    
with open(filesdir + "FLsigWarp.txt") as myfile:
    for l in enumerate(myfile):
        s = s + 1
		
with open(filesdir + "FLwoolz.txt") as myfile:
    for l in enumerate(myfile):
        n = n + 1
    	    
with open(filesdir + "FLshow.txt") as myfile:
    for l in enumerate(myfile):
        w = w + 1
    	    
d=((w*1.0)/(t*1.0))*100.0	

print '[%d] -> %d => %d -> %d -> %d -| %d'%(t, p, s, n, w, d)


	
			
