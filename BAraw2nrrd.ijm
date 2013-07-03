/** Convert  nrrd files to tiff
* @param: dirname - folder where the source stack is located.
* The full path to the stack is then presumed to be dirname/*-fastwarp.nrrd
* The stack exploded as a series of tifs in dirname/tiff/
*/

// rm original files disabled temp

function processfile(fromfname) {
  print("Processing File " + fromfname);
  
  extention = "_rigid.raw";
  name = "";

    if (!endsWith(fromfname, extention))
    {
      print ("Not valid file extention: " + fromfname + " != " + extention);
    }
    else
    {
    	
      	print ("Converting " + fromfname);
	dirname = substring(fromfname, 0, indexOf(fromfname, "GMR_")); 
	print (dirname);
	filename = replace(replace(fromfname,dirname,""),".raw","");
	if (File.exists(dirname + filename + ".raw"))
        {
	print ("Processing signal file:" + filename);
	print("opening: "+ filename + ".raw" + " => " + filename + "_blue.nrrd");

	run("raw reader", "open=" + dirname + filename + ".raw");
	
	print("open file ok ");
	
	//run("Properties...", "unit=µm pixel_width=0.4612588 pixel_height=0.4612588 voxel_depth=0.46 frame=[0 sec] origin=0,0");
	run("Split Channels");
	run("Nrrd ... ", "nrrd=[" + dirname + filename + "_blue.nrrd]");
	close();
	wait(5000);
	run("Nrrd ... ", "nrrd=[" + dirname + filename + "_green.nrrd]");
        close();
	if (File.exists(dirname + filename + "_blue.nrrd"))
	{
	    print ("Successfully exploded the signal nrrd file");
	    print ("raw file NOT deleted");
	}
	
	File.append(dirname + filename + "_blue.nrrd", "FLwarpR.txt")
	}	
  }
 
}



filelist = File.openAsString("FLrigid.txt");
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




