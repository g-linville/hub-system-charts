#!/bin/bash

set -e -x

cd docs/

# Clean up old packages
rm ./*

# Package base chart
helm package ../

# Package subcharts
packages=(
  "../charts/aws-cloud-controller-manager"
  "../charts/istio/istiod"
)
for package in "${packages[@]}"; do
  helm package "$package"
  pushd "$package"
  helm dep up
  popd
done

# Update index
cd ..
helm repo index --url https://acorn-io.github.io/hub-system-charts/ ./docs
