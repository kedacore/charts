<p align="center"><img src="https://raw.githubusercontent.com/kedacore/keda/main/images/keda-logo-transparent.png" width="300"/></p>
KEDA allows for fine grained autoscaling (including to/from zero) for event driven Kubernetes workloads. KEDA serves as a Kubernetes Metrics Server and allows users to define autoscaling rules using a dedicated Kubernetes custom resource definition.

KEDA can run on both the cloud and the edge, integrates natively with Kubernetes components such as the Horizontal Pod Autoscaler, and has no external dependencies.

We are a Cloud Native Computing Foundation (CNCF) incubation project.
![CNCF Logo](https://raw.githubusercontent.com/kedacore/keda/main/images/logo-cncf.svg)

## Getting Started

### Adding our Helm chart repo

```console
$ helm repo add kedacore https://kedacore.github.io/charts
"kedacore" has been added to your repositories
```

### Browse all our Helm charts

```console
$ helm search repo kedacore
NAME                                            CHART VERSION   APP VERSION     DESCRIPTION
kedacore/external-scaler-azure-cosmos-db        0.1.0           0.1.0           Event-based autoscaler for Azure Cosmos DB chan...
kedacore/keda                                   2.9.3           2.9.2           Event-based autoscaler for workloads on Kubernetes
kedacore/keda-add-ons-http                      0.2.2           0.2.0           Event-based autoscaler for HTTP workloads on Ku...
```

## Releases

You can find the latest releases [here](https://github.com/kedacore/charts/releases).

## Contributing

You can find contributing guide [here](./CONTRIBUTING.md).
