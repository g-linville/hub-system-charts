#!/bin/sh
set -e -x

cd docs/
helm package ../
cd ..
helm repo index --url https://acorn-io.github.io/hub-system-charts/ .
mv index.yaml docs/