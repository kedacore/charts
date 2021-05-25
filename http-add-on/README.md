<p align="center"><img src="https://github.com/kedacore/keda/raw/main/images/logos/keda-word-colour.png" width="300"/></p>

<p style="font-size: 25px" align="center"><b>Kubernetes-based Event Driven Autoscaling - HTTP Add-On</b></p>
<p style="font-size: 25px" align="center">

The KEDA HTTP Add On allows Kubernetes users to automatically scale their HTTP servers up and down (including to/from zero) based on incoming HTTP traffic. Please see our [use cases document](./docs/use_cases.md) to learn more about how and why you would use this project.

| 🚧 **Alpha - Not for production** 🚧|
|---------------------------------------------|
| ⚠ The HTTP add-on is in [experimental stage](https://github.com/kedacore/keda/issues/538) and not ready for production. <br /><br />It is provided as-is without support.

>This codebase moves very quickly. We can't currently guarantee that any part of it will work. Neither the complete feature set nor known issues may be fully documented. Similarly, issues filed against this project may not be responded to quickly or at all. **We will release and announce a beta release of this project**, and after we do that, we will document and respond to issues properly.

## Walkthrough

Although this is an **alpha release** project right now, we have prepared a walkthrough document that with instructions on getting started for basic usage.

See that document at [docs/walkthrough.md](https://github.com/kedacore/http-add-on/tree/main/docs/walkthrough.md)

## Design

The HTTP add-on is composed of multiple mostly independent components. This design was chosen to allow for highly
customizable installations while allowing us to ship reasonable defaults.

- We have written a complete design document. Please see it at [docs/design.md](https://github.com/kedacore/http-add-on/tree/main/docs/design.md).
- For more context on the design, please see our [scope document](https://github.com/kedacore/http-add-on/tree/main/docs/scope.md).
- If you have further questions about the project, please see our [FAQ document](https://github.com/kedacore/http-add-on/tree/main/docs/faq.md).

## Installation

Please see the [complete installation instructions](https://github.com/kedacore/http-add-on/tree/main/docs/install.md).

## Contributing

Please see the [contributing documentation for all instructions](https://github.com/kedacore/http-add-on/tree/main/docs/contributing.md).

---
We are a Cloud Native Computing Foundation (CNCF) sandbox project.
<p align="center"><img src="https://raw.githubusercontent.com/kedacore/keda/main/images/logo-cncf.svg" height="75px"></p>

---

## TL;DR

```console
helm repo add kedacore https://kedacore.github.io/charts
helm repo update

helm install http-add-on kedacore/http-add-on --create-namespace --namespace keda
```

## Introduction

This chart bootstraps KEDA HTTP Add-on infrastructure on a Kubernetes cluster using the Helm package manager.

As part of that, it will install all the required Custom Resource Definitions (CRD).

## Installing the Chart

To install the chart with the release name `http-add-on`, please read the [install instructions on the official repository to get started](https://github.com/kedacore/http-add-on/tree/main/docs/install.md):

```console
$ helm install http-add-on kedacore/http-add-on --namespace keda
```

> **Important:** This chart **needs** KEDA installed in your cluster to work properly.

## Uninstalling the Chart

To uninstall/delete the `http-add-on` Helm chart:

```console
helm uninstall http-add-on
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the Promitor chart and
their default values.

| Parameter                                                  | Description                               | Default                                         |
|:-----------------------------------------------------------|:------------------------------------------|:------------------------------------------------|
| `images.tag`                                               | Image tag for the http add on             | None, it uses Helm chart's app version as a default                              |
| `images.operator`                                          | Image name for the operator image component | `ghcr.io/kedacore/http-add-on-operator:latest` |
| `images.interceptor`                                       | Image name for the interceptor image component | `ghcr.io/kedacore/http-add-on-interceptor:latest` |
| `images.scaler`                                            | Image name for the scaler image component | `ghcr.io/kedacore/http-add-on-scaler:latest` |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example:

```console
$ helm install http-add-on kedacore/http-add-on --namespace keda \
               --set version=<different tag from app version>
```

Alternatively, a YAML file that specifies the values for the above parameters can
be provided while installing the chart. For example,

```console
helm install http-add-on kedacore/http-add-on --namespace keda -f values.yaml
```
