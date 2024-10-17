#!/bin/bash

#Destory the already installed cluster
/$USER/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example,com --destroy -y

#BUILD OCP 4.17.0 CLUSTER

/$USER/ocp4_setup_upi_kvm/ocp4_setup_upi_kvm.sh --cluster-name ocp --cluster-domain lab.example.com --ocp-version 4.17.0 --pull-secret /$USER/pull_secret.txt -y
