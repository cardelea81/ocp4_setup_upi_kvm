#Start OCP VM's cluster

#!/bin/bash
echo "Start the OCP VM's"
for i in $(virsh list --all | awk '{print $2}' | grep ocp); do virsh start $i ; done

