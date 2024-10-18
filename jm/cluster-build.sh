#!/bin/bash
#Jenkins Master build
#Destroy old cluster
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example,com --destroy -y

#Build the new ocp cluster
sudo /hudson/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example.com --ocp-version 4.17.0 --pull-secret /hudson/pull_secret.txt -y

#Change /hudson owner
sudo chown -R hudson:hudson /hudson
