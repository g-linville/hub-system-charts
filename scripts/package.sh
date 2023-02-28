#!/bin/sh
set -e -x

cd docs/
helm package ../
helm package ../charts/aws-cloud-controller-manager
cd ..
helm repo index --url https://acorn-io.github.io/hub-system-charts/ ./docs
