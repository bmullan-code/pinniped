#!/bin/bash
kubectl create clusterrolebinding my-user-admin --clusterrole admin --user bmullan

kubectl create clusterrolebinding my-group-admin --clusterrole admin --user group2
