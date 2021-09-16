#!/bin/bash

# Script to backup images from an Openstack Cloud

# Read the options
while [[ $# -gt 0 ]]
do
	key=$1

	case $key in
		--images)
			image_list=$2
			shift
			shift
			;;
		*)
			printf "Wrong option %s\n --------- \n" $key
			exit 1
			;;
	esac
done

image_dir="images_bak"
mkdir $image_dir && cd $image_dir || exit

if [[ ! -z ${image_list+x} ]]
then
	for i in $(echo $image_list | sed "s/,/ /g")
	do
		image_id=$(openstack image show $i | grep "| id " | cut -f 3 -d "|")
    	glance image-download --file $i $image_id
		echo "Downloaded $i"
		sleep 2
	done
else
	openstack image list > os_image_file1.txt
	sleep 2
	num=num=$(wc -l < os_image_file1.txt)
	num=$(( $num-1 ))
	sed -n "4,${num}p" os_image_file1.txt > os_image_file2.txt
	sleep 1
	cut -f 2 -d "|" os_image_file2.txt > os_image_file3.txt
	sleep 1
	cut -f 3 -d "|" os_image_file2.txt > os_image_file4.txt

	while read -r f1 && read -r f2 <&3;
	do
		glance image-download --file $f2 $f1
		echo "Downloaded $f2"
		image_list=${image_list}$f2,
		sleep 2
	done < os_image_file3.txt 3<os_image_file4.txt
fi

read -p "Transfer images to a remote server? (Warning: This will copy the ssh key to the remote server) [y/N]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	read -p "Remote server IP: " server_ip
	read -p "Remote server Username: " server_username
	read -p "Path to remote server: " server_path
	echo "Copy ssh key to remote server"
	ssh-copy-id $server_username@$server_ip || ( ssh-keygen && ssh-copy-id $server_username@$server_ip )

	for image in $(echo $image_list | sed "s/,/ /g")
	do
	  scp ${image} ${server_username}@${server_ip}:${server_path}
	  sleep 1
	done

	read -p "Remove images from local server? " -n 1 -r
	echo    # (optional) move to a new line
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	    cd ..
	    rm -r $image_dir
	fi
fi
	
rm -f os_image_file{1..4}.txt &>/dev/null
