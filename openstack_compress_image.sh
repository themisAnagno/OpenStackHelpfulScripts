#!/bin/bash

# Script to compress image that's uploaded on Glance/Openstack image repo

read -p "Image ID: " imageID

glance image-download --file snapshot_image.raw $imageID
echo "image with $imageID downloaded"
read -p  "New image name: " new_image
virt-sparsify --compress snapshot_image.raw $new_image.qcow2
echo "Image $new_image compressed"

# openstack image create $new_image --file $new_image --disk-format qcow2 --container-format bare --public

