#!/bin/bash
#

# For assume that every chart is deployed to every envrionment.
# Later we use Helmfile to make deployment more clearly.
#
# Get charts
for chart in $(ls charts); do 
  # First do a static analysis
  helm lint charts/${chart}
  # Create helm chart package per environment
  helm package charts/${chart} ${chart}
done

    