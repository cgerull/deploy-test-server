#!/bin/bash
#

# For assume that every chart is deployed to every envrionment.
# Later we use Helmfile to make deployment more clearly.
#
# Get charts
for chart in $(ls charts); do 
  # Create kubernetes manifests per environment
  for env in $(ls deploy); do 
    echo "Extract manifest ${chart} for ${env}."
    helm template charts/${chart} --values=deploy/${env}/${chart}.yaml > kubernetes/${env}/${chart}.yaml
  done
done

# Validate manifests
# if [ $(kubectl get nodes 2&1 > /dev/nulls) ]; then
#     for env in $(ls deploy); do
#         kubectl apply -f kubernetes/${env}/${chart}.yaml --dry-run=client
#     done
# fi