#!/bin/bash
#
# from https://argo-cd.readthedocs.io/en/stable/getting_started/
#
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# brew install argocd
#
# Enable port-forwarding
# kubectl port-forward svc/argocd-server -n argocd 8443:443
#
# Get initial password 
# kubectl get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
