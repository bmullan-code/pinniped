#!/bin/bash

echo "---should work---"
MY_CLUSTER_ACCESS_TOKEN=bmullan:password123 kubectl --kubeconfig my-cluster.yaml get namespaces

echo "---should fail---"
MY_CLUSTER_ACCESS_TOKEN=bmullan2:password123 kubectl --kubeconfig my-cluster.yaml get namespaces

echo "---should work---"
MY_CLUSTER_ACCESS_TOKEN=bmullan2:password123 kubectl --kubeconfig my-cluster.yaml get pods -n local-user-authenticator
