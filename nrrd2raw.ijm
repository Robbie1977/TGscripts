name = getArgument;
if (name=="") exit ("No argument!");
setBatchMode(true);
path = getDirectory("startup");
ch1 = replace(name, "warp.raw", "SGwarp.nrrd");
ch2 = replace(name, "warp.raw", "BGwarp.nrrd");
run("Nrrd ...", "load=[" + path + ch1 + "]");
run("Nrrd ...", "load=[" + path + ch2 + "]");
run("Merge Channels...", "c1=" + ch1 + " c2=" + ch2 + " create ignore");


run("raw writer", "save=[" + name +"]");


close();
run("Quit");

