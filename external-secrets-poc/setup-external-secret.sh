#!/bin/bash
#
# A configured vault with the KeyValue Engine is required.
# Requirements:
#   process (shell) should be already logged in to vault
#   kubectl is able to access the correct cluster
#   external-secrets should be installed in the cluster
#
# The scripts helps with the setup and configuration of kubernetes authentication
# and the connection to secret store in a kubernetes cluster.
#

# Cluster / project or installation name
PRIFIX=demo
KV_PATH="kv/data/path/to/my/secret"


vault policy write ${PRIFIX}-policy -<<EOF     
path ${KV_PATH}                                                  
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
sa_secret_name="$(kubectl get serviceaccount external-secrets -n external-secrets -o json | jq '.secrets[0].name' | tr -d '"')"
sa_account_token="$(kubectl get secret ${sa_secret_name} -n external-secrets -o json | jq '.data.token' | tr -d '"' | base64 -d)" 

vault write auth/kubernetes/role/${PRIFIX}-role \
    bound_service_account_names=external-secrets \
    bound_service_account_namespaces=es \
    policies=${PRIFIX}-policy \
    ttl=24h

vault write auth/kubernetes/login role=${PRIFIX}-role jwt=${sa_account_token} iss=https://kubernetes.default.svc.cluster.local