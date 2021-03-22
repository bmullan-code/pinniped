#!/bin/bash

kubectl run curlpod --image=curlimages/curl --command -- /bin/sh -c "while true; do echo hi; sleep 120; done"

echo 'sleeping for 10 seconds'
sleep 10
echo 'awake'

kubectl cp /tmp/local-user-authenticator-ca curlpod:/tmp/local-user-authenticator-ca

echo 'sleeping for 5 seconds'
sleep 5

kubectl -it exec curlpod -- curl https://local-user-authenticator.local-user-authenticator.svc/authenticate \
  --cacert /tmp/local-user-authenticator-ca \
  -H 'Content-Type: application/json' -H 'Accept: application/json' -d '
{
  "apiVersion": "authentication.k8s.io/v1beta1",
  "kind": "TokenReview",
  "spec": {
    "token": "bmullan:password123"
  }
}' \
> user.json
cat user.json | jq



