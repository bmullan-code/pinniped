# pinniped
pinniped

https://pinniped.dev/docs/tutorials/concierge-only-demo/

# Create a local authenticator

Install
```
kubectl apply -f https://get.pinniped.dev/latest/install-local-user-authenticator.yaml
```


Create a sample user
```
kubectl create secret generic pinny-the-seal \
  --namespace local-user-authenticator \
  --from-literal=groups=group1,group2 \
  --from-literal=passwordHash=$(htpasswd -nbBC 10 x password123 | sed -e "s/^x://")
```
 
Fetch the CA certificate
```
kubectl get secret local-user-authenticator-tls-serving-certificate --namespace local-user-authenticator \
  -o jsonpath={.data.caCertificate} \
  | base64 -d \
  | tee /tmp/local-user-authenticator-ca
```

# Deploy Pinniped Concierge
```
kubectl apply -f https://get.pinniped.dev/latest/install-pinniped-concierge.yaml
```

Create a webhook authenticator
```
cat <<EOF | kubectl create -f -
apiVersion: authentication.concierge.pinniped.dev/v1alpha1
kind: WebhookAuthenticator
metadata:
  name: local-user-authenticator
spec:
  endpoint: https://local-user-authenticator.local-user-authenticator.svc/authenticate
  tls:
    certificateAuthorityData: $(cat /tmp/local-user-authenticator-ca-base64-encoded)
EOF
```

Install the pinniped cli
```
brew install vmware-tanzu/pinniped/pinniped-cli
```

Generate a kubeconfig which uses a static token from the env variable MY_CLUSTER_ACCESS_TOKEN
```
pinniped get kubeconfig \
  --static-token-env MY_CLUSTER_ACCESS_TOKEN \
  > my-cluster.yaml
```

Create a role and binding
```
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: local-user-authenticator
  name: bmullan2-namespace-role
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

```
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: group2-rolebinding
  namespace: local-user-authenticator
subjects:
- kind: Group
  name: group2
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: bmullan2-namespace-role
  apiGroup: rbac.authorization.k8s.io
```

Test it out
```
echo "---should work---"
MY_CLUSTER_ACCESS_TOKEN=bmullan:password123 kubectl --kubeconfig my-cluster.yaml get namespaces

echo "---should fail---"
MY_CLUSTER_ACCESS_TOKEN=bmullan2:password123 kubectl --kubeconfig my-cluster.yaml get namespaces

echo "---should work---"
MY_CLUSTER_ACCESS_TOKEN=bmullan2:password123 kubectl --kubeconfig my-cluster.yaml get pods -n local-user-authenticator

```




