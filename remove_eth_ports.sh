#!/bin/bash

# Script to remove any redundant ports created by Katana SM

openstack port list | grep eth > tmp_file1.txt
sleep 2
cut -f 2 -d "|" tmp_file1.txt > tmp_file2.txt

input="tmp_file2.txt"
while IFS= read -r line
do
  openstack port delete $line
  sleep 2
done < "$input"

rm -f tmp_file{1..2}.txt