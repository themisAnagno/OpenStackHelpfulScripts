#!/bin/bash

# Script to remove any redundant security group

openstack security group list > file1.txt
sleep 2
num=num=$(wc -l < file1.txt)
num=$(( $num-1 ))
sed -n "4,${num}p" file1.txt > file2.txt
sleep 1
cut -f 2 -d "|" file2.txt > file3.txt
sleep 1

input="file3.txt"
while IFS= read -r line
do
  openstack security group delete $line
  sleep 2
done < "$input"

rm -f file{1..3}.txt