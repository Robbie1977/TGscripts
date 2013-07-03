/** Convert  nrrd files to tiff
* @param: dirname - folder where the source stack is located.
* The full path to the stack is then presumed to be dirname/*-fastwarp.nrrd
* The stack exploded as a series of tifs in dirname/tiff/
*/

// rm original files disabled temp

function processfile(fromfname) {
  print("Processing File " + fromfname);
  
  extention = "-affine.nrrd";
  name = "";

    if (!endsWith(fromfname, extention))
    {
      print ("Not valid file extention: " + fromfname + " != " + extention);
    }
    else
    {
    	
      	print ("Converting " + fromfname);
	dirname = substring(fromfname, 0, indexOf(fromfname, "VFB-")); 
	print (dirname);
	filename = replace(replace(fromfname,dirname,""),".nrrd","");
	if (File.exists(dirname + filename + ".nrrd"))
        {
	print ("Processing signal file:" + filename);
	print("opening: "+ filename + ".nrrd" + " => " + filename + ".tif");

	run("Nrrd ...", "load=" + dirname + filename + ".nrrd");
	print("open file ok ");
	run("Flip Vertically", "stack");
	saveAs("Tiff", dirname + filename + ".tif");

	wait(5000);
        close();
	if (File.exists(dirname + filename + ".tif"))
	{
	    print ("Successfully exploded the signal nrrd file");
	    print ("nrrd file deleted");
	}
	
	File.append(dirname + filename + ".tif", "FLlocal.txt")
	}	
  }
 
}



filelist = File.openAsString("FLbrainA.txt");
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




