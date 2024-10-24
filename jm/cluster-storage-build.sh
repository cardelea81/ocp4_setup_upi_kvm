#!/bin/bash
#Jenkins Master build OCP cluster and storage nodes
#Destroy old cluster
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example,com --destroy -y

#Build the new ocp cluster
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example.com --ocp-version 4.17.0 --pull-secret /hudson/pull_secret.txt -y

#Change /hudson owner
sudo chown -R hudson:hudson /hudson


#Storage nodes

source /hudson/ocp4_cluster_ocp/env
INSTDIR=/hudson/ocp4_cluster_ocp
export $INSTDIR
#Change /hudson owner
sudo chown -R hudson:hudson /hudson

#storage-1
sudo $INSTDIR/add_node.sh --cpu 4 --memory 16000 --add-disk 50 --add-disk 100 --name storage-1
#storage-2
sudo $INSTDIR/add_node.sh --cpu 4 --memory 16000 --add-disk 50 --add-disk 100 --name storage-2
#storage-3
sudo $INSTDIR/add_node.sh --cpu 4 --memory 16000 --add-disk 50 --add-disk 100 --name storage-3

#nodes CSR and approve them 
for x in $(oc get csr | grep Pending | awk '{print $1}'); do oc adm certificate approve $x; done
sleep 15

#Label the new nodes
/usr/local/bin/oc label node storage-1.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node storage-2.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node storage-3.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''

sudo chown -R hudson:hudson /hudson
