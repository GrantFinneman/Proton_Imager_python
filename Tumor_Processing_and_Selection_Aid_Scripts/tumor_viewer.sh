#!/bin/bash
top_dir="/home/gmf/Downloads/TCGA-BLCA"

# this is a program that removes all spaces from filenames that has to be installed with apt
detox -r $top_dir

dir_array=($(find $top_dir -type d))
off_set=0

# this makes the file Macro.ijm so only the script file needs to be copied to a computer
echo 'run("Image Sequence...", "open=/home/gmf/Downloads/TCGA-BLCA/TCGA-DK-AA6M/06-17-2000-CT_UROGRAM-69154/1.000000-Scout-66630/1-1.dcm sort ");' > Macro.ijm

for index in ${!dir_array[@]}; do

	directory=${dir_array[$((index + off_set))]}
	count=$(ls -1 $directory/*.dcm 2>/dev/null | wc -l)

	if [[ $count -eq 0 ]]; then continue; fi

	file_array=($directory/*)
	first_file=${file_array[0]}

	echo "The index + off_set is: $((index + off_set))"
	echo "The current file name is: $first_file"
	echo ""

	sed -i "s!open=.*\"!open=$first_file sort \"!g" Macro.ijm
	imagej Macro.ijm 1>/dev/null

done


