#!/usr/bin/bash
  
echo "Starting deployment..."

mkdir `pwd`/ocp
cp `pwd`/install-config.yaml `pwd`/ocp
touch /home/cloud-user/scripts/ocp/.openshift_install.log

tail -f /home/cloud-user/scripts/ocp/.openshift_install.log | awk '/Waiting up to 30m0s for bootstrapping to complete.../ { system("/home/cloud-user/scripts/ocp-api-inject.sh") } /Waiting up to 1h0m0s for the cluster at/ { system("/home/cloud-user/scripts/ocp-api-inject.sh") }' &

`pwd`/openshift-baremetal-install --dir=ocp --log-level debug create cluster

pkill tail
