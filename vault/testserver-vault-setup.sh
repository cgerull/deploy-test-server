#!/bin/bash
#
vault secrets enable -path=local kv-v2
#
vault kv put local/mysql/config username="<db-user>" password="<db-password>"
vault kv put local/testserver/testsecret secret="<vaultTestSecret>"

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