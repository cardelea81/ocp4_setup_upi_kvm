#!/bin/bash
#Jenkins Master build OCP cluster and storage nodes
#Remove old storage hosts entry 
sudo /usr/bin/sed -i.bak '/storage-*/d' /etc/hosts
#Destroy old cluster
sudo chown -R hudson:hudson /hudson
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example,com --destroy -y
sudo /hudson/ocp4_setup_upi_kvm/jm/storage-destroy.sh

#Build the new ocp cluster
sudo chown -R hudson:hudson /hudson
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example.com --ocp-version 4.17.0 --pull-secret /hudson/pull_secret.txt -y
source /hudson/ocp4_cluster_ocp/env
INSTDIR=/hudson/ocp4_cluster_ocp
export $INSTDIR="/hudson/ocp4_cluster_ocp"
#Change /hudson owner
sudo chown -R hudson:hudson /hudson
#storage-1
sudo $INSTDIR/add_node.sh --cpu 4 --memory 16000 --add-disk 50 --add-disk 100 --name storage-1
#storage-2
sudo $INSTDIR/add_node.sh --cpu 4 --memory 16000 --add-disk 50 --add-disk 100 --name storage-2
#storage-3
sudo $INSTDIR/add_node.sh --cpu 4 --memory 16000 --add-disk 50 --add-disk 100 --name storage-3

export SDIR="/hudson/ocp4_setup_upi_kvm"
export SETUP_DIR="/hudson/ocp4_cluster_ocp"
export DNS_DIR="/etc/NetworkManager/dnsmasq.d"
export VM_DIR="/var/lib/libvirt/images"
export KUBECONFIG="/hudson/ocp4_cluster_ocp/install_dir/auth/kubeconfig"
export CLUSTER_NAME="ocp"
export BASE_DOM="lab.example.com"


#nodes CSR and approve them 

seq 200 | for x in $(/usr/local/bin/oc get csr | grep Pending | awk '{print $1}'); do /usr/local/bin/oc adm certificate approve $x; done
sleep 20m
source /hudson/ocp4_cluster_ocp/env


#Label worker nodes for storage
/usr/local/bin/oc label node storage-1.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node storage-2.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node storage-3.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''

#Remove worker spec from masters/control-plane 
/usr/local/bin/oc patch scheduler cluster --type merge -p '{"spec":{"mastersSchedulable":false}}'
#The cluster can be unrecoverable when the upgrade of control plane nodes starts
/usr/local/bin/oc patch mcp master --type=merge -p "{\"spec\":{\"maxUnavailable\": 12 }}"
/usr/local/bin/oc patch mcp worker --type=merge -p "{\"spec\":{\"maxUnavailable\": 13 }}"

sudo chown -R hudson:hudson /hudson
