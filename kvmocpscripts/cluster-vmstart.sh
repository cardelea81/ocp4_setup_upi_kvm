#Start OCP VM's cluster

#!/bin/bash
echo "Start the OCP VM's"
for i in $(sudo virsh list --all | awk '{print $2}' | grep ocp); do sudo virsh start $i ; done

echo "Enable FW ports"
source /hudson/ocp4_cluster_ocp/./env
/hudson/ocp4_cluster_ocp/expose_cluster.sh --method firewalld
