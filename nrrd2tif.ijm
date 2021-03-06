// ImageJ macro lsm2nrrdPP.ijm Ver 3.03
// Designed to open and PreProcess 2 channel LSM (or tif) image stacks and output 2 NRRD files
// Written by Robert Court - r.court@ed.ac.uk 


name = getArgument;
if (name=="") exit ("No argument!");
setBatchMode(true);

outfile = replace(name, ".nrrd", ".tif");

run("Nrrd ...", "load=[" + name + "]");
saveAs("Tiff", outfile);


run("Quit");

