#!/bin/bash
pinniped get kubeconfig \
  --static-token-env MY_CLUSTER_ACCESS_TOKEN \
  > my-cluster.yaml


