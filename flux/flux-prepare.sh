#!/bin/bash
#
# Install Flux components
#
export GITHUB_USER=cgerull
export GITHUB_TOKEN=***************
#
flux bootstrap github \
    --owner="$GITHUB_USER" \
    --personal \
    --repository=flux \
    --branch=main \
    --path=./clusters/k3d-dev
#
# Install Aquasecurity operator
#
kubectl create ns starboard-system
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
kubectl create ns testserver
#
flux create source git testserver \
    --url=https://github.com/cgerull/deploy-test-server.git \
    --branch=main
#
flux create kustomization testserver \
  --target-namespace=testserver \
  --source=testserver \
  --path="./kubernetes/dev-local/" \
  --prune=true \
  --interval=5m