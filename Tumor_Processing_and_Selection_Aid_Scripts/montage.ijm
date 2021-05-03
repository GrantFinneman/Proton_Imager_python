setBatchMode('hide');
run("MetaImage Reader ...", "open=../cubic_tumor_collections/28_28_28_tumors/tumor_28_28_28_0802.mha");
run("Make Montage...", "columns=1 rows=28 scale=1");
saveAs("Text Image",
"../cubic_tumor_collections/28_28_28_tumors/tumor_28_28_28_0802_montage.txt");
run("Quit");
