#!/bin/bash
#
flux bootstrap github \
    --owner="$GITHUB_USER" \
    --personal \
    --repository=flux-example \
    --branch=main \
    --path=./clusters/minikube
#
flux create source helm starboard-operator \
    --url https://aquasecurity.github.io/helm-charts \
    --namespace starboard-system
#
flux create helmrelease starboard-operator \
    --chart starboard-operator \
    --source HelmRepository/starboard-operator \
    --chart-version 0.10.8 \
    --namespace starboard-system
#
#
# Install an app to deploy
#
flux create source git testserver \
    --url=https://github.com/cgerull/deploy-test-server.git \
    --branch=main
#
flux create kustomization testserver-app \
  --target-namespace=app \
  --source=testserver \
  --path="./kubernetes/dev-local/" \
  --prune=true \
  --interval=5m