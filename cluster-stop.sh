#Cluster shutdown 

#!/bin/bash

echo "Mark all the nodes in the cluster as unschedulable"
for node in $(oc get nodes -o jsonpath='{.items[*].metadata.name}'); do echo ${node} ; oc adm cordon ${node} ; done

echo "Evacuate the pods"
for node in $(oc get nodes -l node-role.kubernetes.io/worker -o jsonpath='{.items[*].metadata.name}'); do echo ${node} ; oc adm drain ${node} --delete-emptydir-data --ignore-daemonsets=true --timeout=15s --force ; done

echo "Shut down all of the nodes in the cluster"
for node in $(oc get nodes -o jsonpath='{.items[*].metadata.name}'); do oc debug node/${node} -- chroot /host shutdown -h 1; done 

echo "Stop the OCP VM's"
for i in $(virsh list --all | awk '{print $2}'); do virsh shutdown $i ; done

