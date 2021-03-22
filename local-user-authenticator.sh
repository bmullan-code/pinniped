#!/bin/bash

# https://github.com/vmware-tanzu/pinniped/blob/main/deploy/local-user-authenticator/README.md

kubectl get secret local-user-authenticator-tls-serving-certificate --namespace local-user-authenticator \
  -o jsonpath={.data.caCertificate} \
  | base64 -d \
  | tee /tmp/local-user-authenticator-ca

