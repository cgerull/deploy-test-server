#!/usr/bin/env bash
set -e

SCRIPT_PATH=$(realpath "${BASH_SOURCE[0]}")
SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")
BASE_DIR=$(realpath "${SCRIPT_DIR}/..")

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Missing GITHUB_TOKEN variable, exiting..."
    exit 1
fi

if ! command -v helmfile &> /dev/null; then
    echo "helmfile command not found, exiting..."
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
    echo "==> Templating helm charts for $NAMESPACE namespace..."

    # Generate Kubernetes manifests using `helmfile template`
    cd $BASE_DIR/helm/values/$NAMESPACE
    helmfile -n $(basename $PWD) template --output-dir-template "{{ .State.BaseName }}"

    # Ensure namespace directory exists
    NAMESPACE_DIR="$BASE_DIR/$OUTPUT_DIR/$NAMESPACE"
    mkdir -p "$NAMESPACE_DIR"

    # Consolidate output into a file per chart
    cd helmfile
    for CHART in *; do
        CHART_FILE="$NAMESPACE_DIR/$CHART.yaml"
        echo "==> Consolidating $CHART chart into $CHART_FILE..."
        rm $CHART_FILE && touch $CHART_FILE
        find $CHART -type f | sort | xargs -n 1 -I % cat % >> "$CHART_FILE"
    done

    # Clean up temporary helmfile dir (handy when running script locally)
    cd .. && rm -rf helmfile

    echo
done
