#!/usr/bin/env bash
set -e

SCRIPT_PATH=$(realpath "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")
BASE_DIR=$(realpath "${SCRIPT_DIR}/..")

if ! command -v helm &> /dev/null
then
    echo "helm command not found, exiting..."
    exit 1
fi

NAMESPACES=$1
if [ -z "$NAMESPACES" ]; then
      echo "Missing namespaces to generate, exiting..."
      exit 1
fi

OUTPUT_DIR=$2
if [ -z "$OUTPUT_DIR" ]; then
      echo "Missing output directory, exiting..."
      exit 1
fi

cd "$BASE_DIR/$CHARTS_DIR" || exit

for NAMESPACE in ${NAMESPACES//,/ }; do
    cd $BASE_DIR/helm/values/$NAMESPACE
    git rm -f "$BASE_DIR/$OUTPUT_DIR/$NAMESPACE/*.yaml"
    for CHART in $(ls *.yaml | sed -e 's/\.yaml//'); do
        CHART_DIR=$(find $BASE_DIR/helm-charts-unreleased $BASE_DIR/helm/charts $BASE_DIR/helm/charts-unreleased -name $CHART -type d)

        if [[ $(echo $CHART_DIR | wc -l) -eq 0 ]]; then
            echo "Could not find chart for value file $NAMESPACE/$CHART.yaml, skipping"
        fi

        if [[ $(echo $CHART_DIR | wc -l) -gt 1 ]]; then
            echo "Found multiple charts for value file $NAMESPACE/$CHART.yaml, skipping"
        fi

        echo "Generating $CHART chart for $NAMESPACE namespace... "
        mkdir -p "$BASE_DIR/$OUTPUT_DIR/$NAMESPACE"
        helm template "$CHART" -f "$BASE_DIR/helm/values/$NAMESPACE/$CHART.yaml" "$CHART_DIR" > "$BASE_DIR/$OUTPUT_DIR/$NAMESPACE/$CHART.yaml"
    done
done
