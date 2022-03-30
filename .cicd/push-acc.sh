#!/bin/bash
#
# upload helm packages
for entry in $(echo "${CHARTSV3_CONFIG_ACC" | jq -r '.[] | @base64'); do
  _jq() {
    echo ${entry} | base64 --decode | jq -r ${1}
  }
  url=$(_jq '.url')
  user=$(_jq '.user')
  password=$(_jq '.password')
  type=$(_jq '.type' | sed "s/null//")
  scheme=$(echo ${url} | sed -E 's|(https?://).+|\1|')
  hosturl=$(echo ${url} | sed -E 's|https?://(.+)|\1|')
  for file in *.tgz; do
    echo "Uploading: ${file} to: ${url}"
    case $type in 
      nexus)
        curl --silent -u ${user}:${password} ${url} --upload-file ${file}
        ;;
      *)
        curl --silent --data-binary "@${file}" "${scheme}${user}:${password}@${hosturl}"
        ;;
    esac
  done
done