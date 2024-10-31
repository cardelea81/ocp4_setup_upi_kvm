#!/bin/bash
#Jenkins Master build
#Destroy old cluster
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example,com --destroy -y

#Build the new ocp cluster
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example.com --ocp-version 4.17.0 --pull-secret /hudson/pull_secret.txt -y

#Change /hudson owner
sudo chown -R hudson:hudson /hudson

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



/usr/local/bin/oc label node worker-1.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node worker-2.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node worker-3.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''

sudo chown -R hudson:hudson /hudson

