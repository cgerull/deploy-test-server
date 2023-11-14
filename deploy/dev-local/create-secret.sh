#!/bin/bash
#
# Create a simple testsecret
# kubectl create secret generic testserver --from-literal=testserver=mytestsecret
#
# Create ACME DNS secret
kubectl create secret generic acme-dns --from-file $HOME/deploy/dev-local/acmedns.json
