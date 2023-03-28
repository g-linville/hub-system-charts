#!/bin/sh
set -e -x

cd docs/
helm package ../
helm package ../charts/aws-cloud-controller-manager
pushd ../charts/linkerd/linkerd-control-plane
helm dep up
popd
helm package ../charts/linkerd/linkerd-control-plane
cd ..
helm repo index --url https://acorn-io.github.io/hub-system-charts/ ./docs
