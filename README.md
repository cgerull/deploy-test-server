# Deploy testserver

## ArgoCD
Install ArgoCD
```bash
kubectl create namespace argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server -n argocd 9433:443
```

Install ArgoCD project.
```bash
argocd proj create testsuite --description "Suite of test services." -d https://kubernetes.default.svc,testserver
```

InstallArgoCD app
```bash
argocd app create testserver --repo  https://github.com/cgerull/deploy-test-server--path kubernetes --dest-server https://kubernetes.default.svc --dest-namespace testserver`--project testsuite
```
