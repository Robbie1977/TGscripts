name = getArgument;
if (name=="") exit ("No argument!");
setBatchMode(true);
path = getDirectory("startup");
ch1 = replace(name, "warp.raw", "SGwarp.nrrd");
ch2 = replace(name, "warp.raw", "BGwarp.nrrd");
run("Nrrd ...", "load=[" + path + ch1 + "]");

//run("Canvas Size...", "width=1024 height=1024 position=Top-Left zero");
//S run("Translate...", "x=297 y=17 interpolation=None stack");
//run("Translate...", "x=298 y=117 interpolation=None stack");
//setSlice(165);
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");

run("Canvas Size...", "width=1024 height=1024 position=Center zero");

run("Nrrd ...", "load=[" + path + ch2 + "]");

//run("Canvas Size...", "width=1024 height=1024 position=Top-Left zero");
//S run("Translate...", "x=297 y=17 interpolation=None stack");
//run("Translate...", "x=298 y=117 interpolation=None stack");
//setSlice(165);
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");
//run("Add Slice");

run("Canvas Size...", "width=1024 height=1024 position=Center zero");

run("Merge Channels...", "c1=" + ch1 + " c2=" + ch2 + " create ignore");



run("raw writer", "save=[" + name +"]");


close();
run("Quit");

