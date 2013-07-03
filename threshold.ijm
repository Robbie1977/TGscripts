 AUTO_THRESHOLD = 5000; 
 getRawStatistics(pixcount); 
 limit = pixcount/10; 
 threshold = pixcount/AUTO_THRESHOLD; 
 nBins = 256; 
 getHistogram(values, histA, nBins); 
 i = -1; 
 found = false; 
 do { 
         counts = histA[++i]; 
         if (counts > limit) counts = 0; 
         found = counts > threshold; 
 } while ((!found) && (i < histA.length-1)) 
 hmin = values[i]; 
 hmin = 10;
 i = histA.length; 
 do { 
         counts = histA[--i]; 
         if (counts > limit) counts = 0; 
         found = counts > threshold; 
 } while ((!found) && (i > 0)) 
 hmax = values[i]; 

 setMinAndMax(hmin, hmax); 
 //print(hmin, hmax); 
 run("Apply LUT"); 
 
 
 
 run("Auto Threshold", "method=[Try all] white");
close();
run("Split Channels");
run("Duplicate...", "title=C2-GMR_10A06_AE_01_04-fA01v_C080119_20080125041315281-1.lsm duplicate range=1-175");

run("Z Project...", "start=1 stop=175 projection=[Max Intensity]");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
run("Apply LUT");
run("Enhance Contrast", "saturated=0.35");
run("Enhance Contrast", "saturated=0.35");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
run("Close");
selectWindow("C1-GMR_10A06_AE_01_04-fA01v_C080119_20080125041315281.lsm");
run("Z Project...", "start=1 stop=175 projection=[Max Intensity]");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("Apply LUT");
run("Apply LUT");
run("Apply LUT");
run("Close");
close();
selectWindow("C1-GMR_10A06_AE_01_04-fA01v_C080119_20080125041315281.lsm");
run("Z Project...", "start=1 stop=175 projection=[Max Intensity]");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
setMinAndMax(4, 32);
call("ij.ImagePlus.setDefault16bitRange", 0);
close();
selectWindow("C1-GMR_10A06_AE_01_04-fA01v_C080119_20080125041315281.lsm");
run("Z Project...", "start=1 stop=175 projection=[Average Intensity]");
close();
run("Close");
selectWindow("C1-GMR_10A06_AE_01_04-fA01v_C080119_20080125041315281.lsm");
close();
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
setMinAndMax(0, 255);
call("ij.ImagePlus.setDefault16bitRange", 0);
run("Close");
