#!/bin/bash

openstack flavor create --vcpus 1 --disk 1 --ram 512 m1.tiny
sleep 5
openstack flavor create --vcpus 1 --disk 20 --ram 2048 m1.small
sleep 5
openstack flavor create --vcpus 2 --disk 40 --ram 4096 m1.medium
sleep 5
openstack flavor create --vcpus 4 --disk 80 --ram 8192 m1.large
sleep 5
openstack flavor create --vcpus 8 --disk 160 --ram 16384 m1.xlarge
sleep 5