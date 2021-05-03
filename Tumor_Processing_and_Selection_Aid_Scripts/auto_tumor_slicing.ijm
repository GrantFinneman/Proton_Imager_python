// This opens an mha file, and splits it into number_of_slices squared equally sized
// and equally spaced segments then saves them in their own directory.
// This script prompts the user to first select a directory that will serve as input
// then ask for a directoy that will be the location where all of the slices are
// saved

// getDirectory need a string as an argument, the value of the string doesn't get used
dir = getDirectory(".");
output_dir = getDirectory(".");

// files is an array of just the file names not the paths
files = getFileList(dir);

// This is the number of slices per axis, so there are number_of_slices * number_of_slices total segment made
number_of_slices = 2;

// Iterates the files in the input directory
for(i=0; i<(files.length); i++){
	setBatchMode("hide"); // This hides all of the windows and SUPER speeds it up, change to false if you want to see the process

	file_name = dir + files[i]; // Name of file that gets opened path + name

	run("MetaImage Reader ...", "open=file_name use_virtual_stack");
	title = getTitle();

	image_width = getWidth();
	image_height = getHeight();

	// Specifies an offset based on the percentage of the length I want to slice
	percentage = 0.75;
	adjusted_width = image_width*percentage;
	adjusted_height = image_height*percentage;
	width_offset = (image_width - adjusted_width)/2;
	height_offset = (image_height - adjusted_height)/2;


	rec_width = adjusted_width/number_of_slices;
	rec_height = adjusted_height/number_of_slices;

	// Iterates through the locations of the top left corner of the rectangle
	for (x_slice=0;x_slice < number_of_slices;x_slice++){
		for (y_slice=0; y_slice < number_of_slices; y_slice++){

			dup_name = output_dir + x_slice + "_" + y_slice + title;

			x_start = x_slice*rec_width + width_offset;
			y_start = y_slice*rec_height + height_offset;

			makeRectangle(x_start, y_start, rec_width, rec_height);
			// wait(2000);

			run("Duplicate...", "duplicate");

			run("MetaImage Writer ...", "save_in_single_file metaimage=dup_name");
			// wait(2000);
			close(); // This closes the currently selected window which by default is any new window. this closes the new duplicant window

			// The wait statements were left over from development
			// if you want to see exactly how the rectangles move
			// uncomment the waits and set batchmode to false

		}
	}

	close();
}
exit();





