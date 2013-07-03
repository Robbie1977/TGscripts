import os, re, shutil, subprocess, fnmatch

filesdir = '/disk/data/flylight/'
outdir = '/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/'

matches = []
for root, dirnames, filenames in os.walk(filesdir):
  for filename in fnmatch.filter(filenames, '*v_*.lsm'):
      matches.append(os.path.join(root, filename))



with open("FLpre.txt", "a") as myfile:
	for fname in matches:
		myfile.write(fname + '\n')
	
print 'Done!'	
			
