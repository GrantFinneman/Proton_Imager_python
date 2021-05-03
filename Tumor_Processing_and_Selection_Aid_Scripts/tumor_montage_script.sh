#!/bin/bash

source_dir=../cubic_tumor_collections/28_28_28_tumors
files=($source_dir/*mha)
output_dir=$source_dir

# contents of ijm file that gest writen each time this is run
echo "setBatchMode('hide');" > montage.ijm
echo 'run("MetaImage Reader ...", "open=./cubic_tumor_collections/28_28_28_B_tumors/tumor_28_28_28_431.mha");' >> montage.ijm
echo 'run("Make Montage...", "columns=1 rows=28 scale=1");' >> montage.ijm
echo 'saveAs("Text Image",' >> montage.ijm
echo '"./cubic_tumor_collections/28_28_28_B_tumors/tumor_28_28_28_431_montage.txt");' >> montage.ijm
echo 'run("Quit");' >> montage.ijm

if [[ ! -d $output_dir ]]; then
	mkdir $output_dir
fi
for file in ${files[@]}; do
	tumor_name=$(basename $file); tumor_name=${tumor_name%.*}
	sed -i "2 s:open=.*\":open=$file\":" montage.ijm
	sed -i "5 s:\".*\":\"$output_dir/${tumor_name}_montage.txt\":" montage.ijm
	imagej ./montage.ijm
done

