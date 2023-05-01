#!/bin/bash

# We use this script to update the CRDs in this chart for prometheus operator.
# To determine the prometheus operator version to use, and for more instructions,
# see https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack.
# The upgrade guide there should specify which version of prometheus operator to use.

if [ -z "$1" ]; then
    echo "Usage: $0 <prometheus-operator chart version>"
    exit 1
fi

REPO_OWNER="prometheus-operator"
REPO_NAME="prometheus-operator"
DIRECTORY_PATH="example/prometheus-operator-crd"
OUTPUT_DIRECTORY="crds"
TAG="$1"
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/contents/$DIRECTORY_PATH?ref=$TAG"

# Make API request to get the list of files in the directory at the specified tag
files=$(curl -s "$API_URL" | jq -r '.[] | .download_url')

# Loop through each file and download it
for file in $files; do
    filename=$(basename "$file")
    echo "Downloading $filename..."
    curl -sLJ "$file" -o "$OUTPUT_DIRECTORY/$filename"
done
