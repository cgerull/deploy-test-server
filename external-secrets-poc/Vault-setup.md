## Install on kubernetes

```bash
# For test and demo install a local vault instance.
# Add hashicorp repo and install helmchart
helm repo add hashicorp https://helm.releases.hashicorp.com

helm install vault hashicorp/vault -n vault --create-namespace

export VAULT_ADDR=http://127.0.0.1:8200

kubectl port-forward svc/vault -n vault 8200:8200 &
vault operator init

# Output
Unseal Key 1: **************************************
Unseal Key 2: **************************************
Unseal Key 3: **************************************
Unseal Key 4: **************************************
Unseal Key 5: **************************************

Initial Root Token: **************************************


# Unseal vault and login
vault operator unseal <key 1>
vault operator unseal <key 2>
vault operator unseal <key 3>

vault login <root token>

# Define kv engine and add secret
vault secrets enable -version=2 kv
vault kv put kv/path/to/my/secret password=secretpassword
#
vault kv put kv/local/cgerull/secret SECRET_KEY=hashicorpVaultSecret
#
```

## Setup kubernetes authentication

Enable kubernetes authentication in Hashicorp vault. 
We need:

- the kubernetes URL
- the kubernetes certificate
- an account token 


```bash
# First create a policy
vault policy write demo-policy -<<EOF     
path "kv/data/path/to/my/secret"                                                  
{  capabilities = ["read"]                
}                         
EOF

## Enable and setup kubernetes authentication


vault auth enable kubernetes

k8s_host="$(kubectl exec vault-0 -n vault -- printenv | grep KUBERNETES_PORT_443_TCP_ADDR | cut -f 2- -d "=" | tr -d " ")"
k8s_port="443"            
k8s_cacert="$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}' | base64 --decode)"
secret_name="$(kubectl get serviceaccount vault -n vault -o jsonpath='{.secrets[0].name}')"
tr_account_token="$(kubectl get secret ${secret_name} -n vault -o jsonpath='{.data.token}' | base64 --decode)"

vault write auth/kubernetes/config \
    token_reviewer_jwt="${tr_account_token}" \
    kubernetes_host="https://${k8s_host}:${k8s_port}" \
    kubernetes_ca_cert="${k8s_cacert}" \    
    disable_issuer_verification=true

# Create vault role
demo_secret_name="$(kubectl get serviceaccount external-secrets -n external-secrets -o json | jq '.secrets[0].name' | tr -d '"')"
demo_account_token="$(kubectl get secret ${demo_secret_name} -n external-secrets -o json | jq '.data.token' | tr -d '"' | base64 -d)"                  

vault write auth/kubernetes/role/demo-role \
    bound_service_account_names=external-secrets \
    bound_service_account_namespaces=external-secrets \
    policies=demo-policy \
    ttl=24h

vault write auth/kubernetes/login role=demo-role jwt=$demo_account_token iss=https://kubernetes.default.svc.cluster.local
```

## Configure external secrets

Create a secret storeto bind the demo-role.

```yaml
apiVersion: external-secrets.io/v1alpha1
kind: SecretStore
metadata:
name: vault-backend
spec:
provider:
    vault:
    server: "http://vault.vault:8200"
    path: "kv"
    version: "v2"
    auth:
        kubernetes:
        mountPath: "kubernetes"
        role: "demo-role"
```

Finally create an external secret

```yaml
apiVersion: external-secrets.io/v1alpha1
kind: ExternalSecret
metadata:
name: vault-example
spec:
secretStoreRef:
    name: vault-backend
    kind: SecretStore
target:
    name: example-sync
data:
- secretKey: foobar
    remoteRef:
    key: path/to/my/secret
    property: password
```
