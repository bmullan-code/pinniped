#!/bin/bash
kubectl create secret generic bmullan \
  --namespace local-user-authenticator \
  --from-literal=groups=group1,group2 \
  --from-literal=passwordHash=$(htpasswd -nbBC 10 x password123 | sed -e "s/^x://")

kubectl create secret generic bmullan2 \
  --namespace local-user-authenticator \
  --from-literal=groups=group2 \
  --from-literal=passwordHash=$(htpasswd -nbBC 10 x password123 | sed -e "s/^x://")
