#!/bin/bash

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
#while true; do
#  for x in $(/usr/local/bin/oc get csr | grep Pending | awk '{print $1}'); do
#    /usr/local/bin/oc adm certificate approve $x;
#  done;
#  sleep 5;
#done


#Label the new nodes
/usr/local/bin/oc label node storage-1.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node storage-2.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node storage-3.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''

sudo chown -R hudson:hudson /hudson
