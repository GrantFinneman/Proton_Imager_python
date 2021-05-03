setBatchMode('hide');
run("MetaImage Reader ...", "open=/home/gmf/Projects/Proton_Imager/Project_Data/cubic_tumor_collections/28_28_28_C_tumors/tumor_28_28_28_1551.mha");
run("Make Montage...", "columns=1 rows=28 scale=1");
saveAs("Text Image",
"/home/gmf/Projects/Proton_Imager/Project_Data/cubic_tumor_collections/28_28_28_C_tumors/tumor_28_28_28_1551_montage.txt");
run("Quit");
