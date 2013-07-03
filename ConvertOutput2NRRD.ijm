// Auto balance brighness and contrast to tif
/* Robert Court */

function processdirectory(fromdname, todir) {
  print("Processing Folder " + fromdname);
  
  filenames = getFileList(fromdname);
  extension = ".tif";
  name = "";

  for(i=0; i < filenames.length; ++i)
  {
    if ((!endsWith(filenames[i], extension)) || (endsWith(filenames[i], "W0W10" + extension)))
    {
      print ("Skipping " + filenames[i]);
    }
    else
    {
//      name = substring(filenames[i], 0, lengthOf(filenames[i]) - 4);
      
//      if (File.exists(todir + name + "_Bal.tif"))
//      {
//        print ("-- balanced file for " + filenames[i] + " already exists - skipping.");
//      }
//      else
//      {        
        print ("Converting " + filenames[i]);
        
        open("/home/s1002628/BrainAligner/" + fromdname + filenames[i]);
        wait(1000);
	
	run("Split Channels");
	wait(300);
	run("Nrrd ... ", "nrrd=[/home/s1002628/BrainAligner/" + todir + filenames[i] + "_blue.nrrd]");
	close();
	run("Nrrd ... ", "nrrd=[/home/s1002628/BrainAligner/" + todir + filenames[i] + "_green.nrrd]");
	close();
	run("Nrrd ... ", "nrrd=[/home/s1002628/BrainAligner/" + todir + filenames[i] + "_red.nrrd]");
	close();
	
        
//      }
    }
  }
 run("Quit");
}

fromdirlistW = "Output/";
todirT = "NRRD/";

processdirectory(fromdirlistW, todirT);

print ("Done!");
