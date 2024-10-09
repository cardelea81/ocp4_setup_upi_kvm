#ocp console check 

oc get all -n openshift-ingress
oc get all -n openshift-console
oc get all -n openshift-authentication-operator
oc get all -n openshift-authentication
oc get all -n openshift-console-operator
oc get all -n openshift-console-user-settings

# Check  auth

oc get pods -n openshift-ingress
oc get pods -n openshift-console
oc get pods -n openshift-authentication
oc get pods -n openshift-authentication-operator
oc get pods -n openshift-console-operator
oc get pods -n openshift-console-user-settings
#
