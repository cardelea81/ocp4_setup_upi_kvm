#!/bin/bash

#Storage nodes

#Remove old storage nodes
for i in $(virsh list --all | awk '{print $2}' | grep storage); do virsh destroy  $i ; done
for i in $(virsh list --all | awk '{print $2}' | grep storage); do virsh undefine  $i --remove-all-storage ; done

#Change /hudson owner
sudo chown -R hudson:hudson /hudson
