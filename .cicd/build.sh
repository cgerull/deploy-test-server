#!/bin/bash --debug
#

# For assume that every chart is deployed to every envrionment.
# Later we use Helmfile to make deployment more clearly.
#
# Get charts
for chart in $(ls charts); do 
  # First do a static analysis
  helm lint charts/${chart}
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
git remote rm origin && git remote add origin "git@$GITLAB_URL:${CI_PROJECT_PATH}.git"
git add kubernetes/*
git commit -m "Build manifests for build ${CI_PIPELINE_IID}" || echo "No changes, nothing to commit!"
git push origin HEAD:$CI_COMMIT_REF_NAME
    