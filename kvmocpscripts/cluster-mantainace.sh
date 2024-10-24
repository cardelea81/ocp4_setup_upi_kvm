#MASTERS MANTAINACE
#/bin/bash
oc adm cordon master-1.ocp.lab.example.com
oc adm cordon master-2.ocp.lab.example.com
oc adm cordon master-3.ocp.lab.example.com
oc adm drain master-1.ocp.lab.example.com --delete-emptydir-data --ignore-daemonsets=true --timeout=15s --force
oc adm drain master-2.ocp.lab.example.com --delete-emptydir-data --ignore-daemonsets=true --timeout=15s --force
oc adm drain master-3.ocp.lab.example.com --delete-emptydir-data --ignore-daemonsets=true --timeout=15s --force
