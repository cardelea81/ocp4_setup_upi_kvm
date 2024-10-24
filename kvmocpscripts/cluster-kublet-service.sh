#!/bin/bash


 for i in master-1.ocp.lab.example.com master-2.ocp.lab.example.com master-3.ocp.lab.example.com worker-1.ocp.lab.example.com worker-2.ocp.lab.example.com ; do ssh -i /$USER/ocp4_cluster_ocp/sshkey core@$i " sudo  hostname  && sudo systemctl status kubelet && sudo systemctl restart  kubelet"  ; done
