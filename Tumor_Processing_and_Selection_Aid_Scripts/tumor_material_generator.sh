#!/bin/bash

tumor_directory=/home/gmf/Projects/Proton_Imager/Project_Data/cubic_tumor_collections/28_28_28_C_tumors
tumor_files=($tumor_directory/*.mha)

index=0

echo 'run("MetaImage Reader ...", "open=../cubic_tumor_collections/test_tumors/tumor_28_28_28_004.mha use_virtual_stack");' > hu_regularizer.ijm
echo 'run("Statistics");' >> hu_regularizer.ijm
echo 'saveAs("Results", "Results.csv");' >> hu_regularizer.ijm
echo 'run("Quit");' >> hu_regularizer.ijm

for tumor in ${!tumor_files[@]}; do

	tumor_path=${tumor_files[$((tumor + index))]}
	tumor_name=$(basename $tumor_path); tumor_name=${tumor_name%.*}

	echo $tumor_path
	echo $output_dir
	sed -i "1 s!open.*mha!open=${tumor_files[$((tumor + index))]}!g" hu_regularizer.ijm
	imagej hu_regularizer.ijm

	min_hu=$(awk -F, 'NR==2 {print $6}' Results.csv)
	max_hu=$(awk -F, 'NR==2 {print $7}' Results.csv)

#	max_hu=${max_hu%.*}
#	min_hu=${min_hu%.*}

	echo "Min HU: $min_hu"
	echo "Max Hu: $max_hu"

	material_table_name=${tumor_name}_material.txt

	echo $tumor_name
	for material in {0..22}; do
		step=$(( max_hu - min_hu + 22 ))
		step=$((step/23))
		new_hu=$((material*step + min_hu))
		register_number=$((material + 9))
		#echo $new_hu
		#echo $register_number
		#awk -v register=$register_number -v value=$new_hu 'FNR==register {$1=value} {print}' $(pwd)/data/Schneider2000MaterialsTable.txt  $material_table_name
		sed -i "${register_number} s/[[:digit:]]*/$new_hu/" ./copiesOfSchneider/Schneider2000MaterialsTable.txt
	done
	cp ./copiesOfSchneider/Schneider2000MaterialsTable.txt $tumor_directory/$material_table_name

	density_table_name=${tumor_name}_density.txt

	for material in {0..4}; do
		step=$(( max_hu - min_hu + 4 ))
		step=$((step/5))
		new_hu=$((material*step + min_hu))
		register_number=$((material + 4))
		#echo $new_hu
		#echo $register_number
		sed -i "${register_number} s/[[:digit:]]*/$new_hu/" ./copiesOfSchneider/Schneider2000DensitiesTable.txt
	done
	cp ./copiesOfSchneider/Schneider2000DensitiesTable.txt $tumor_directory/$density_table_name

	cat $tumor_directory/$density_table_name
	cat $tumor_directory/$material_table_name
	cat Results.csv
done

rm Results.csv
rm hu_regularizer.ijm






# remove all of the first column of hashtags the files had some lines commented out to begin with so those lines need the hashtags

## copy of Schneider2000DensitiesTable
## ===================
## HU	density g/cm3
## ===================
#33092	1.21e-3
#33460	0.93
#33828	0.930486
#34196	1.03
#34564	1.031

## copy of Schneider2000MaterialsTable
#[Elements]
#Hydrogen  Carbon Nitrogen Oxygen Sodium Magnesium Phosphor Sulfur
#Chlorine Argon Potassium Calcium
#Titanium Copper Zinc  Silver Tin
#[/Elements]
## ===============================================================================
## HU      H    C    N    O   Na  Mg   P   S   Cl  Ar  K   Ca  Ti  Cu Zn  Ag  Sn
## ===============================================================================
#32804    0    0  75.5 23.2  0   0    0   0   0  1.3  0    0  0   0  0   0   0      Air
#32884  10.3 10.5  3.1 74.9 0.2  0   0.2 0.3 0.3  0  0.2   0  0   0  0   0   0      Lung
#32964  11.6 68.1  0.2 19.8 0.1  0    0  0.1 0.1  0   0    0  0   0  0   0   0    AT_AG_SI1
#33044   11.3 56.7  0.9 30.8 0.1  0    0  0.1 0.1  0   0    0  0   0  0   0   0    AT_AG_SI2
#33124   11.0 45.8  1.5 41.1 0.1  0   0.1 0.2 0.2  0   0    0  0   0  0   0   0    AT_AG_SI3
#33204   10.8 35.6  2.2 50.9  0   0   0.1 0.2 0.2  0   0    0  0   0  0   0   0    AT_AG_SI4
#33284    10.6 28.4  2.6 57.8  0   0   0.1 0.2 0.2  0  0.1   0  0   0  0   0   0    AT_AG_SI5
#33364   10.3 13.4  3.0 72.3 0.2  0   0.2 0.2 0.2  0  0.2   0  0   0  0   0   0   SoftTissus
#33444    9.4 20.7  6.2 62.2 0.6  0    0  0.6 0.3  0  0.0   0  0   0  0   0   0 ConnectiveTissue
#33524    9.5 45.5  2.5 35.5 0.1  0   2.1 0.1 0.1  0  0.1  4.5 0   0  0   0   0  Marrow_Bone01
#33604    8.9 42.3  2.7 36.3 0.1  0   3.0 0.1 0.1  0  0.1  6.4 0   0  0   0   0  Marrow_Bone02
#33684    8.2 39.1  2.9 37.2 0.1  0   3.9 0.1 0.1  0  0.1  8.3 0   0  0   0   0  Marrow_Bone03
#33764   7.6 36.1  3.0 38.0 0.1 0.1  4.7 0.2 0.1  0   0  10.1 0   0  0   0   0  Marrow_Bone04
#33844    7.1 33.5  3.2 38.7 0.1 0.1  5.4 0.2    0 0   0  11.7 0   0  0   0   0  Marrow_Bone05
#33924    6.6 31.0  3.3 39.4 0.1 0.1  6.1 0.2  0   0   0  13.2 0   0  0   0   0  Marrow_Bone06
#34004    6.1 28.7  3.5 40.0 0.1 0.1  6.7 0.2  0   0   0  14.6 0   0  0   0   0  Marrow_Bone07
#34084    5.6 26.5  3.6 40.5 0.1 0.2  7.3 0.3  0   0   0  15.9 0   0  0   0   0   Marrow_Bone08
#34164    5.2 24.6  3.7 41.1 0.1 0.2  7.8 0.3  0   0   0  17.0 0   0  0   0   0  Marrow_Bone09
#34244   4.9 22.7  3.8 41.6 0.1 0.2  8.3 0.3  0   0   0  18.1 0   0  0   0   0  Marrow_Bone10
#34324   4.5 21.0  3.9 42.0 0.1 0.2  8.8 0.3  0   0   0  19.2 0   0  0   0   0  Marrow_Bone11
#34404   4.2 19.4  4.0 42.5 0.1 0.2  9.2 0.3  0   0   0  20.1 0   0  0   0   0  Marrow_Bone12
#34484   3.9 17.9  4.1 42.9 0.1 0.2  9.6 0.3  0   0   0  21.0 0   0  0   0   0  Marrow_Bone13
#34564   3.4 15.5  4.2 43.5 0.1 0.2 10.3 0.3  0   0   0  22.5 0   0  0   0   0  Marrow_Bone15

