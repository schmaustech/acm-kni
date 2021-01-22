#!/usr/bin/bash
export KUBECONFIG=/home/cloud-user/scripts/ocp/auth/kubeconfig
sleep 30
oc patch etcd cluster -p='{"spec": {"unsupportedConfigOverrides": {"useUnsupportedUnsafeNonHANonProductionUnstableEtcd": true}}}' --type=merge
oc patch authentications.operator.openshift.io cluster -p='{"spec": {"managementState": "Managed", "unsupportedConfigOverrides": {"useUnsupportedUnsafeNonHANonProductionUnstableOAuthServer": true}}}' --type=merge
oc patch -n openshift-ingress-operator ingresscontroller/default -p='{"spec":{"replicas": 1}}' --type=merge
oc patch clusterversion/version -p="$(cat <<- EOF
 spec:
    overrides:
      - group: apps/v1
        kind: Deployment
        name: etcd-quorum-guard
        namespace: openshift-machine-config-operator
        unmanaged: true
EOF
)" --type=merge
oc scale --replicas=1 deployment/etcd-quorum-guard -n openshift-etcd
oc patch -n openshift-ingress-operator ingresscontroller/default --patch '{"spec":{"replicas": 1}}' --type=merge
