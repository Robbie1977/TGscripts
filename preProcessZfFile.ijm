// Auto balance brighness and contrast to tif
/* Robert Court */


function processfile(fromfname, tofile) {
  print("Processing File " + fromfname);
  
  extention = ".lsm";
  name = "";
  hmin = 15;
  hmax = 4079;

    if (!endsWith(fromfname, extention))
    {
      print ("Not valid file extention: " + fromfname + " != " + extention);
    }
    else
    {
     if (File.exists(fromfname))
     {
      	if (File.exists(tofile + "_no")) // FIX ME!!
      	{
      	    print ("File warp in progress! Skipping " + fromfname);
            filelist = File.openAsString("FLpreZf.txt");
            lines=split(filelist,"\n"); 
            str = "";
            for(i=0; i < lines.length; ++i)	{
	            if (endsWith(lines[i], (fromfname + " -Done"))) 
	            {
		            lines[i] = fromfname;    
		        }
	            str = str + lines[i] + "\n";
            }
            File.saveString(str, "FLpreZf.txt") 
      	}
      	else
      	{ 
      	print ("Converting " + fromfname);
      	
      	name = replace(tofile,".nrrd", "");      
	
      	open(fromfname);
        wait(2000);

	// Auto Balance removed as problematic

	slices = 0;

	// we need to know only how many slices there are
	getDimensions(dummy, dummy, dummy, slices, dummy);

	slice = floor(slices/2);

	//name = name + "_Adj"; // note the Auto brightness adjustment in filename. 

	

	//run("8-bit");
	//wait(300);
	
			
	run("Split Channels");
	wait(800);
	//setSlice(slice); 
	//getMinAndMax(hmin, hmax);
	wait(800);
	//levlog="BG:"+d2s(hmin,0)+","+d2s(hmax,0);
	
	
	
	run("Grouped Z Project...", "projection=[Max Intensity] group="+slices);
	//run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
    wait(300);
    getMinAndMax(hmin, hmax);
    wait(100);
	levlog="BG:"+d2s(hmin,0)+","+d2s(hmax,0);
    run("Enhance Contrast", "saturated=0.35");
    wait(300);
    getMinAndMax(hmin, hmax);
    wait(100);
    close();
    wait(300);
    setMinAndMax(hmin, hmax);
    wait(300);
	levlog=levlog+"->"+d2s(hmin,0)+","+d2s(hmax,0)+".";
	
	//run("Brightness/Contrast...");
    //run("Enhance Contrast", "saturated=0.35");
    //setMinAndMax(15, 4079);
    //call("ij.ImagePlus.setDefault16bitRange", 0);
    //run("Close");
	//setMinAndMax(hmin, hmax);
	//run("Apply LUT"); 
	//ImageProcessor ip = dot_blot.getProcessor().duplicate();  
    //ip.setMinAndMax(hmin, hmax);
	//imp.setDisplayRange(hmin, hmax);
	//setMinAndMax(15, 4079);
	//call("ij.ImagePlus.setDefault16bitRange", 0);
	//run("Enhance Contrast", "saturated=0.35");
    //run("Apply LUT", "stack");   
    //Dialog.show()   
	wait(800);
	run("Flip Z"); // resolves upside down warps. 
	wait(300);
	run("Rotate... ", "angle=-45 grid=1 interpolation=Bilinear stack"); //remove diagonal tilt to right
	wait(800);
	// trial measure
	run("Translate...", "x=0 y=-73 interpolation=None stack");
	wait(300);
	run("8-bit");
	wait(300);
	run("Nrrd ... ", "nrrd=[" + name + "_Zf_blue.nrrd]");
	wait(800);
	close();
	wait(100);
	
	//setSlice(slice); 
	//getMinAndMax(hmin, hmax);
	wait(800);
	//levlog=levlog+";SG:"+d2s(hmin,0)+","+d2s(hmax,0);
	
	
	
	run("Grouped Z Project...", "projection=[Max Intensity] group="+slices);
	//run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
    wait(300);
    getMinAndMax(hmin, hmax);
    wait(100);
	levlog=levlog+";SG:"+d2s(hmin,0)+","+d2s(hmax,0);
    run("Enhance Contrast", "saturated=0.35");
    wait(300);
    getMinAndMax(hmin, hmax);
    wait(100);
    
    //Dialog.show("check contrast")
    close();
    wait(300);
    setMinAndMax(hmin, hmax);
    wait(300);
    
    //run("Apply LUT", "stack");
	levlog=levlog+"->"+d2s(hmin,0)+","+d2s(hmax,0)+". ROT:(-45)deg.";
	run("Flip Z"); // resolves upside down warps. 
	wait(300);
	run("Rotate... ", "angle=-45 grid=1 interpolation=Bilinear stack"); //remove diagonal tilt to right
	wait(800);
	// trial measure
	run("Translate...", "x=0 y=-73 interpolation=None stack");
	wait(300);
	run("8-bit");
	wait(300);
	run("Nrrd ... ", "nrrd=[" + name + "_Zf_green.nrrd]");
	wait(800);
	close();
	
	File.saveString(levlog+"\r\n", name+"_Zf_Meta.txt");
		 }     
     }
  }
 
}


for(j=0; j < 1000; ++j)
{

str = "";
fname="";
c = 0;
filelist = File.openAsString("FLpreZf.txt");
lines=split(filelist,"\n"); 

for(i=0; i < lines.length; ++i)	{
	if ((!endsWith(lines[i], "-Done")) && (c < 1))
	{
		fname = lines[i];
		if (File.exists(fname))
        {
		    lines[i] = lines[i] + " -Done";    
		    c = c +1;
		}
	}
	str = str + lines[i] + "\n";
}
File.saveString(str, "FLpreZf.txt")

temp = "/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/";

rname = temp + replace(replace(replace(fname,".lsm",".nrrd"),"/disk/data/", ""),"/","-");

if (c>0) {
	print ("Selected file " + fname);
	processfile(fname, rname);
	File.append(replace(rname,".nrrd","_Zf_blue.nrrd"), "FLwarpZf.txt") 
}else{
	print ("No files to process " + fname);
}
if (c==0) {
	run("Quit");
}



}
print ("Done!");
run("Quit");

