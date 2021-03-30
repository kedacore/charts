<p align="center"><img src="https://raw.githubusercontent.com/kedacore/keda/main/images/keda-logo-transparent.png" width="300"/></p>
KEDA allows for fine grained autoscaling (including to/from zero) for event driven Kubernetes workloads. KEDA serves as a Kubernetes Metrics Server and allows users to define autoscaling rules using a dedicated Kubernetes custom resource definition.

KEDA can run on both the cloud and the edge, integrates natively with Kubernetes components such as the Horizontal Pod Autoscaler, and has no external dependencies.

We are a Cloud Native Computing Foundation (CNCF) sandbox project.
![CNCF Logo](https://raw.githubusercontent.com/kedacore/keda/main/images/logo-cncf.svg)

## Getting Started
### Adding our Helm chart repo

```console
$ helm repo add kedacore https://kedacore.github.io/charts
"kedacore" has been added to your repositories
```

### Browse all our Helm charts
```
$ helm search repo kedacore/
NAME            CHART VERSION   APP VERSION     DESCRIPTION
kedacore/keda	2.0.1        	2.0.0      	Event-based autoscaler for workloads on Kubernetes
```

## Releases

You can find the latest releases [here](https://github.com/kedacore/charts/releases).

## Contributing

You can find contributing guide [here](./CONTRIBUTING.md).
