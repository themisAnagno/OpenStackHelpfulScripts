#!/bin/bash

# Script to upload openstack images from a folder

read -p "Folder name: " folder_name

if [ ! -d $folder_name ] 
then
    echo "Directory $folder_name DOES NOT exists." 
    exit 9999 # die with error code 9999
fi

cd $folder_name

for image in *; do
	openstack image create $image --file $image --disk-format qcow2 --container-format bare --public
	echo "Image $image uploaded"
	sleep 300
done