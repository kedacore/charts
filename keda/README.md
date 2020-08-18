<p align="center"><img src="https://raw.githubusercontent.com/kedacore/keda/master/images/keda-logo-transparent.png" width="300"/></p>
<p style="font-size: 25px" align="center"><b>Kubernetes-based Event Driven Autoscaling</b></p>

KEDA allows for fine grained autoscaling (including to/from zero) for event driven Kubernetes workloads.  KEDA serves as a Kubernetes Metrics Server and allows users to define autoscaling rules using a dedicated Kubernetes custom resource definition.

KEDA can run on both the cloud and the edge, integrates natively with Kubernetes components such as the Horizontal Pod Autoscaler, and has no external dependencies.

---
<p align="center">
We are a Cloud Native Computing Foundation (CNCF) sandbox project.

<img src="https://raw.githubusercontent.com/kedacore/keda/master/images/logo-cncf.svg" height="75px">
</p>

---

## TL;DR

```console
helm repo add kedacore https://kedacore.github.io/charts
helm repo update

kubectl create namespace keda
helm install keda kedacore/keda --namespace keda
```

## Introduction

This chart bootstraps KEDA infrastructure on a Kubernetes cluster using the Helm package manager.

As part of that, it will install all the required Custom Resource Definitions (CRD).

## Installing the Chart

To install the chart with the release name `keda`:

```console
$ kubectl create namespace keda
$ helm install keda kedacore/keda --namespace keda
```

## Uninstalling the Chart

To uninstall/delete the `keda` Helm chart:

```console
helm uninstall keda
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Promitor chart and
their default values.

| Parameter                  | Description                               | Default                                         |
|:---------------------------|:------------------------------------------|:------------------------------------------------|
| `image.keda`               | Image name of KEDA operator               | `docker.io/kedacore/keda:1.5.0`                 |
| `image.metricsAdapter`     | Image name of KEDA Metrics Adapter        | `docker.io/kedacore/keda-metrics-adapter:1.5.0` |
| `image.pullPolicy`         | Policy to use to pull Docker images       | `Always`                                        |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example:

```console
$ helm install keda kedacore/keda --namespace keda \
               --set image.keda='<image-name>'
```

Alternatively, a YAML file that specifies the values for the above parameters can
be provided while installing the chart. For example,

```console
helm install keda kedacore/keda --namespace keda -f values.yaml
```