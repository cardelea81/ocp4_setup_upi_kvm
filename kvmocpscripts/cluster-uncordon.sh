#Cluster MANTAINACE uncordon
#/bin/baish
for node in $(oc get nodes -o jsonpath='{.items[*].metadata.name}'); do oc adm uncordon node/${node}; done
