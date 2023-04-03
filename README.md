# hub-system-charts
This repository is a helm chart that contains all the charts that are used by provisioned Hub clusters.

## Charts
The `charts` directory contains forked charts that require edits beyond the scope that their values originally provided. If at all possible,
we should avoid forking charts and should instead the values should be updated to provide the desired functionality in `templates`. However, 
if that is not possible, the forked chart should be kept as close to the original as possible.

To package all these `charts`, run `./scripts/package.sh`. This will package the charts into the `docs` directory so long as the script
has been updated to be aware of any new charts.

### Istio
For the purposes of using istio withing provisioned clusters, we have forked the upstream `Istiod` chart and setup:

1. Two replicas for the `Istiod Deployment` that use `podAntiAffinity` to keep one on a master node and the other on worker nodes.
1. The Istiod Service in the `istio-system` namespace to only select the `Istiod` pods with the `on-master: "false"` label.
1. A new Service in the `istio-system` namespace called `istiod-remote` that only selects `Istiod` pods with the `on-master: "true"` label.
1. The `MutatingWebhookConfiguration` to send requests to the `istiod-remote` `Service` only.

These edits were not possible outside of directly editing the chart. The upstream chart's values would not allow us to do this so we had to fork it.

## Templates
The `templates` directory contains the k3s `HelmChart` resources. These deploy the charts packaged from the `charts` directory as well as any other upstream charts. They can
be controlled to be deployed or not via the `values.yaml` file.

## Docs
The `docs` directory contains the packaged helm charts. They are served via GitHub pages at https://acorn-io.github.io/hub-system-charts/{chart}.tgz. While they
can be installed individually, they are intended to be installed all together via the aggregate chart defined by `Chart.yaml`.

Currently, these include:
- https://acorn-io.github.io/hub-system-charts/istiod-1.17.1.tgz
- https://acorn-io.github.io/hub-system-charts/aws-cloud-controller-manager-0.0.7.tgz
- https://acorn-io.github.io/hub-system-charts/hub-system-charts-0.0.1.tgz
