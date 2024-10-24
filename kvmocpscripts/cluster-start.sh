#Start VM's cluster

#!/bin/bash
export /$USER/ocp4_cluster_ocp/install_dir/auth/kubeconfig
echo "Open Firewall"
/$USER/ocp4_cluster_ocp/./expose_cluster.sh --method firewalld
echo "Basic cluster checks "
oc get nodes -l node-role.kubernetes.io/master
oc get nodes -l node-role.kubernetes.io/worker
oc get clusteroperators
oc get nodes
echo "Mark all the nodes in the cluster as schedulable"
for node in $(oc get nodes -o jsonpath='{.items[*].metadata.name}'); do echo ${node} ; oc adm uncordon ${node} ; done
