#!/bin/bash
#

#JSON is default
# echo -n mySealedSecret | kubectl create secret generic testserver --dry-run=client --from-file=testserver=/dev/stdin -o json >testsecret.json
# ❯ cat testsecret.json

# But YAML is better for human users
# Create secret from and store in a local file
echo -n mySealedSecret | kubectl create secret generic testserver --dry-run=client --from-file=testserver=/dev/stdin -o yaml >testsecret.yaml

# Seal it with the target namespace
kubeseal -n testserver -o yaml <testsecret.yaml >testsealedsecret.yaml

# Create secret in namespace
kubectl apply -f testsealedsecret.yaml

# Check 
kubectl get secret testsecret