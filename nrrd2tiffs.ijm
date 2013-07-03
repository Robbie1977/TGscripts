/** Convert  nrrd files to tiff
* @param: dirname - folder where the source stack is located.
* The full path to the stack is then presumed to be dirname/*-fastwarp.nrrd
* The stack exploded as a series of tifs in dirname/tiff/
*/

// rm original files disabled temp

function processfile(fromfname) {
  print("Processing File " + fromfname);
  
  extention = ".nrrd";
  name = "";

    if (!endsWith(fromfname, extention))
    {
      print ("Not valid file extention: " + fromfname + " != " + extention);
    }
    else
    {
    	
      	print ("Converting " + fromfname);
	dirname = substring(fromfname, 0, indexOf(fromfname, "flylight-")); 
	print (dirname);
	filename = replace(replace(fromfname,dirname,""),".nrrd","");
	testname = replace(filename,"-warpedSig","-fastwarp");
	if (File.exists(dirname + testname + ".nrrd"))
        {
	print ("Processing signal file:" + filename);
	nrrddir = dirname;
	tiffdir = nrrddir + "tiff/";
	print("opening: "+ nrrddir + filename + ".nrrd" + " => " + tiffdir + filename);

	run("Nrrd ...", "load=" + nrrddir + filename + ".nrrd");
	print("open file ok ");
	run("8-bit");
	wait(1000);

	command = "format=TIFF name=" + filename + " digits=3 save=" + tiffdir;
	run("Image Sequence... ", command);
	wait(5000);
	if (File.exists(tiffdir + filename + "002.tif"))
	{
	    print ("Successfully exploded the signal nrrd file");
	    File.delete(nrrddir + filename + ".nrrd");
	    print ("nrrd file deleted");
	}
	close();
	print ("Processing background file:" + filename);
	filename = replace(filename,"-warpedSig","-fastwarp");
	print("opening: "+ nrrddir + filename + ".nrrd" + " => " + tiffdir + filename);
	run("Nrrd ...", "load=" + nrrddir + filename + ".nrrd");
	print("open file ok ");
	run("8-bit");
	wait(1000);
	command = "format=TIFF name=" + filename + " digits=3 save=" + tiffdir;
	run("Image Sequence... ", command);
	wait(5000);
	if (File.exists(tiffdir + filename + "002.tif"))
	{
	    print ("Successfully exploded the background nrrd file");
	    File.delete(nrrddir + filename + ".nrrd");
	    print ("nrrd file deleted");
	}
	close();
	print ("Passing data for conversion");
	File.append(tiffdir + replace(filename,"-fastwarp",""), "FLshow.txt")
	}	
  }
 
}



filelist = File.openAsString("FLwoolz.txt");
lines=split(filelist,"\n"); 


temp = "/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/";

for(i=0; i < lines.length; ++i)	{
	print ("Selected file " + lines[i]);
	if (File.exists(lines[i]))
	{	
		processfile(lines[i]);
	}
}
	 
 run("Quit");




