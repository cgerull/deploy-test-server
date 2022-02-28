# Deploy testserver

## Kubernetes
Three flavours of Kubernetes deployment are supported.
- direct via manifest
- via helm
- via ArgoCD

Base for all 3 deployments is the helm-chart. You can add templates and change setting in the values.yaml.
Then you generate the kubernetes manifest with:
```bash
# Create one manifest file with all objects.
helm template testerver helm/testserver > kubernetes/testserver.yaml
# Create one manifest per object
helm template testserver helm/testserver  --include-crds --output-dir kubernetes/
```

Start the application with
```bash
# Via helm install
helm install testerver helm/testserver --dry-run && \
helm install testerver helm/testserver
# Direct via kubectl
kubectl apply -f kubernetes/testserver.yaml --dry-run=testserver && \
kubectl apply -f kubernetes/testserver.yaml
```

### ArgoCD
Install ArgoCD
```bash
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 9433:443
```

Install ArgoCD project.
```bash
argocd proj create testsuite --description "Suite of test services." -d https://kubernetes.default.svc,testserver --src https://github.com/cgerull/deploy-test-server
```

InstallArgoCD app
```bash
argocd app create testserver --repo https://github.com/cgerull/deploy-test-server --path kubernetes --dest-server https://kubernetes.default.svc --dest-namespace testserver --project testsuite
```
