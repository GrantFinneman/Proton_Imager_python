dir = getDirectory(".");
files = getFileList(dir);
setBatchMode("hide");

for (i=0; i<files.length; i++){

	file_name = dir + files[i];
	run("MetaImage Reader ...", "open=file_name");
	run("Statistics");
	close();



}
saveAs("Results", "Results.csv");
run("Quit");
