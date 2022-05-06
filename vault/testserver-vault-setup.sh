#!/bin/bash
#
vault kv put internal/mysql/config username="root" password="db-secret-password"

vault policy write testserver - <<EOF
path "internal/data/mysql/config" {
  capabilities = ["read"]
}
EOF

vault write auth/kubernetes/role/testserver \
    bound_service_account_names=testserver \
    bound_service_account_namespaces=testserver \
    policies=testserver \
    ttl=24h