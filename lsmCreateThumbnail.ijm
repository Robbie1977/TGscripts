// Auto balance brighness and contrast to tif
/* Robert Court */

function processdirectory(fromdname, todir) {
  print("Processing Folder " + fromdname);
  
  //find /disk/data/flylight/catalog/jpg/ -type f >> lsmTNfiles.txt

  str=File.openAsString(fromdname);

  lines=split(str,"\n");

  filenames = lines;


  extension = ".jpg";
  name = "";

  for(i=0; i < filenames.length; ++i)
  {
    
    if ( (!endsWith(filenames[i], extension)) || ((indexOf(filenames[i],"v",0)) < 0) )
    {
      print ("Skipping " + filenames[i]);
    }
    else
    {
      	name = substring(filenames[i], 34, lengthOf(filenames[i]) - 48);
	if (startsWith(name, "/"))
	{
		name=substring(name, 1, lengthOf(name) - 1);      
	}
	if (endsWith(name, "_"))
        {
                name=substring(name,0,lengthOf(name)-1);
        }
	print (name);
//      if (File.exists(todir + name + ".gif"))
//      {
//        print ("-- balanced file for " + filenames[i] + " already exists - skipping.");
//      }
//      else
//      {        
        print ("Converting " + filenames[i]);
        
        open(filenames[i]);
        wait(1000);
	run("Thumbnail Maker");
	print("saving " + name);
	wait(1000);
	name=todir + name+".gif";
	saveAs("Gif", name);
	close();
	wait(100);
	close();
	
        
//      }
    }
  }
 run("Quit");
}

fromdirlistW = "/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/logs/lsmTNfiles.txt";
todirT = "/disk/data/VFB/IMAGE_DATA/Janelia2012/TG/stacks/";

processdirectory(fromdirlistW, todirT);

print ("Done!");
