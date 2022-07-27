#!/bin/sh
#
keys=(
    **************************************
)
root_token="**************************************"

export VAULT_ADDR=http://127.0.0.1:8200

count=0
echo $keys
for key in ${keys[*]}; do
    echo $key
    vault operator unseal ${key}
    ((count=count+1))
    if [[ 3 -eq ${count} ]]; then 
        break
    fi 
done

vault login ${root_token}