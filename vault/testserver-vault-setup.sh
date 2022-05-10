#!/bin/bash
#
vault kv put local/mysql/config username="root" password="db-secret-password"
vault kv put local/testserver/testsecret secret="vaultTestSecret"

vault policy write testserver - <<EOF
path "local/data/mysql/config" {
  capabilities = ["read"]
}
path "local/data/testserver/testsecret" {
  capabilities = ["read"]
}
EOF

vault write auth/kubernetes/role/testserver \
    bound_service_account_names=testserver \
    bound_service_account_namespaces=testserver \
    policies=testserver \
    ttl=24h