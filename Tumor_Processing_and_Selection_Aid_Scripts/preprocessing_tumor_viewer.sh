#!/bin/bash
# This opens all of the mha files in the directory cancer_output_images in
# imagej for 10 seconds. It then prompts the user if they would like to keep the
# tumor they saw. If kept it keeps going, if they want to remove it, the file
# they saw gets moved to a directory called garbage_tumors and the process repeats

if [[ ! -d garbage_tumors ]]; then
	mkdir garbage_tumors
fi

if [[ ! -d kept_tumors ]]; then
	mkdir kept_tumors
fi
image_array=(cancer_output_images/*.mha)

for file in ${!image_array[@]}; do

	echo "run(\"MetaImage Reader ...\", \"open=${image_array[$file]} use_virtual_stack\");" > temp_viewer.ijm
	echo "wait(10000);" >> temp_viewer.ijm
	echo "close();" >> temp_viewer.ijm
	echo 'run("Quit")' >> temp_viewer.ijm
	imagej temp_viewer.ijm > /dev/null


	offset=0
	while true; do

		echo -e "\n\noffset: $file"
		echo -e "filename: ${image_array[$((file + offset))]}"
		read -p "Do you want to keep it? (yes, no): " answer

		if [[ "no" == $answer ]]; then
			mv ${image_array[$file]} garbage_tumors/
			echo -e "\nIt was removed"
			break
		elif [[ $answer == "yes" ]]; then
			mv ${image_array[$file]} kept_tumors/
			echo -e "\nIt was kept"
			break
		else
			echo -e "\nYou didn't enter a valid option"
		fi
	done



done

rm temp_viewer.ijm
