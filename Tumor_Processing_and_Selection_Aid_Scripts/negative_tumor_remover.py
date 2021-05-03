#!/home/gmf/.anaconda3/envs/Grant/bin/python
import glob
import os
tumor_dir = "/home/gmf/Projects/Proton_Imager/Project_Data/cubic_tumor_collections/28_28_28_C_tumors/*mha"
with open("Results.csv") as file:
    min_values = []
    file.readline()
    for line in file:
        data = line.split(",")
        min_values.append(float(data[6]))
        #print(data)
files = sorted(glob.glob(tumor_dir))
#print(files)

for value, file in zip(min_values, files):
    #print(file, value)
    if value < 0:
        print(value, file)
        os.remove(file)
