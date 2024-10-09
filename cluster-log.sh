#ocp console 

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

echo 'Logs from openshift-console'
for i in $(oc get all -n openshift-console  | grep pod/*); do oc logs -n openshift-console $i; done
echo 'Logs from openshift-ingress'
for i in $(oc get all -n openshift-ingress  | grep pod/*); do oc logs -n openshift-ingress $i; done
echo 'Logs from openshift-authentication-operator'
for i in $(oc get all -n openshift-authentication-operator  | grep pod/*); do oc logs -n openshift-authentication-operator $i; done
echo 'Logs from openshift-authentication'
for i in $(oc get all -n openshift-authentication  | grep pod/*); do oc logs -n openshift-authentication $i; done
echo 'Logs from openshift-console-operator'
for i in $(oc get all -n openshift-console-operator  | grep pod/*); do oc logs -n openshift-console-operator $i; done
echo 'Logs from openshift-console-user-settings'
for i in $(oc get all -n openshift-console-user-settings  | grep pod/*); do oc logs -n openshift-console-user-settings $i; done


