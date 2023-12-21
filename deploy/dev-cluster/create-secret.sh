#!/bin/bash
#
# Create a simple testsecret
kubectl create secret generic testserver --from-literal=testserver=dev-cluster-secret --namespace=testserver --dry-run=client -o yaml > /tmp/testsecret
kubectl config set-context --current --namespace=testserver
kubeseal --scope namespace-wide --format yaml < /tmp/testsecret > sealed-testsecret.yaml
rm /tmp/testsecret