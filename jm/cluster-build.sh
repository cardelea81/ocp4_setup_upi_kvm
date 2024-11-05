#!/bin/bash
#Jenkins Master build
#Destroy old cluster
sudo /usr/bin/sed -i.bak '/storage-*/d' /etc/hosts
#Destroy old cluster
sudo chown -R hudson:hudson /hudson
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example,com --destroy -y
sudo /hudson/ocp4_setup_upi_kvm/jm/storage-destroy.sh

#Build the new ocp cluster
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example.com --ocp-version 4.17.0 --pull-secret /hudson/pull_secret.txt -y

#Change /hudson owner
sudo chown -R hudson:hudson /hudson

#nodes CSR and approve them

seq 200 | for x in $(/usr/local/bin/oc get csr | grep Pending | awk '{print $1}'); do /usr/local/bin/oc adm certificate approve $x; done
sleep 20m
source /hudson/ocp4_cluster_ocp/env

#Label worker nodes for storage

/usr/local/bin/oc label node worker-1.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node worker-2.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''
/usr/local/bin/oc label node worker-3.${CLUSTER_NAME}.${BASE_DOM} cluster.ocs.openshift.io/openshift-storage=''

sudo chown -R hudson:hudson /hudson

#Remove worker spec from masters/control-plane
/usr/local/bin/oc patch scheduler cluster --type merge -p '{"spec":{"mastersSchedulable":false}}'

#The cluster can be unrecoverable when the upgrade of control plane nodes starts
/usr/local/bin/oc patch mcp master --type=merge -p "{\"spec\":{\"maxUnavailable\": 12 }}"
/usr/local/bin/oc patch mcp worker --type=merge -p "{\"spec\":{\"maxUnavailable\": 13 }}"

