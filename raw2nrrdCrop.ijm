name = getArgument;
if (name=="") exit ("No argument!");
setBatchMode(true);
run("raw reader", "open=[" + name + "]");
path = replace(name, ".raw", "");
run("Split Channels");

//S makeRectangle(297, 17, 433, 983);
//makeRectangle(298, 117, 423, 983);
//run("Crop");
//run("Make Substack...", "  slices=1-165");
run("Canvas Size...", "width=512 height=1024 position=Center zero");

run("Nrrd ... ", "nrrd=[./" + path + "_C2.nrrd]");
close();
//close();

//S makeRectangle(297, 17, 433, 983);
//makeRectangle(298, 117, 423, 983);
//run("Crop");
//run("Make Substack...", "  slices=1-165");
run("Canvas Size...", "width=512 height=1024 position=Center zero");

run("Nrrd ... ", "nrrd=[./" + path + "_C1.nrrd]");
close();
//close();
run("Quit");

