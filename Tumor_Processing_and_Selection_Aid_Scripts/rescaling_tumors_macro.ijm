input_dir = getDirectory(".");
output_dir = getDirectory(".");
slice_number = 28;

files = getFileList(input_dir);
setBatchMode("hide");

print("x=- y=- z=- width=slice_number height=slice_number depth=slice_number interpolation=Bicubic average process create");
file_name_number = 1000;
for (file_index=0; file_index < files.length; file_index++){

	file_name = input_dir + files[file_index];
	run("MetaImage Reader ...", "open=file_name");
	run("Min...", "value=0 stack");

	run("Scale...", "x=- y=- z=- width=28 height=28 depth=28 interpolation=Bicubic average process create");

	Stack.setXUnit("mm");
	Stack.setYUnit("mm");
	Stack.setZUnit("mm");
	run("Properties...", "channels=1 slices=28 frames=1 pixel_width=2.0000 pixel_height=2.0000 voxel_depth=2.0000");

	scaled_name = output_dir + "tumor_" + slice_number + "_" + slice_number + "_" + slice_number + "_" + leftPad(file_name_number, 4) + ".mha";
	run("MetaImage Writer ...", "save_in_single_file metaimage=scaled_name");

	file_name_number++;
	close();
	close();
}

// Converts 'n' to a string, left padding with zeros
// so the length of the string is 'width'
function leftPad(n, width) {
	s =""+n;
	while (lengthOf(s)<width)
	    s = "0"+s;
	return s;
}
