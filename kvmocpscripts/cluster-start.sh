#Check cluster and uncordon 

#!/bin/bash
source /$USER/ocp4_cluster_ocp/env
echo "Basic cluster checks "
oc get nodes -l node-role.kubernetes.io/master
oc get nodes -l node-role.kubernetes.io/worker
oc get clusteroperators
oc get nodes
echo "Mark all the nodes in the cluster as schedulable"
for node in $(oc get nodes -o jsonpath='{.items[*].metadata.name}'); do echo ${node} ; oc adm uncordon ${node} ; done
