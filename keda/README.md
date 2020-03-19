# Kubernetes Event Driven Autoscaling (KEDA)

[Kubernetes Event Driven Autoscaling (KEDA)](https://keda.sh) is a Kubernetes-based Event Driven Autoscaler allowing you to drive the scaling of any container in Kubernetes based on the number of events needing to be processed.

KEDA is a single-purpose and lightweight component that can be added into any Kubernetes cluster. KEDA works alongside standard Kubernetes components like the horizontal pod autoscaler and can extend functionality without overwriting or duplication.

With KEDA you can explicitly map the apps you want to use event driven scale, with other apps continuing to function. This makes KEDA a flexible and safe option to run alongside any number of any other Kubernetes applications or frameworks.

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

To uninstall/delete the `keda` deployment:

```console
helm uninstall keda
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Promitor chart and
their default values.

| Parameter                  | Description              | Default              |
|:---------------------------|:-------------------------|:---------------------|
| `image.keda`  | Image name of KEDA operator | `docker.io/kedacore/keda:1.3.0` |

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