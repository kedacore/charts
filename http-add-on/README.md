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
We are a Cloud Native Computing Foundation (CNCF) graduated project.
<p align="center"><img src="https://raw.githubusercontent.com/kedacore/keda/main/images/logo-cncf.svg" height="75px"></p>

---

## TL;DR

```console
helm repo add kedacore https://kedacore.github.io/charts
helm repo update

helm install http-add-on kedacore/keda-add-ons-http --create-namespace --namespace keda
```

## Introduction

This chart bootstraps KEDA HTTP Add-on infrastructure on a Kubernetes cluster using the Helm package manager.

As part of that, it will install all the required Custom Resource Definitions (CRD).

## Installing the Chart

To install the chart with the release name `http-add-on`, please read the [install instructions on the official repository to get started](https://github.com/kedacore/http-add-on/tree/main/docs/install.md):

```console
$ helm install http-add-on kedacore/keda-add-ons-http --namespace keda
```

> **Important:** This chart **needs** KEDA installed in your cluster to work properly.

## Uninstalling the Chart

To uninstall/delete the `http-add-on` Helm chart:

```console
helm uninstall http-add-on
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Configuration

The following table lists the configurable parameters of the HTTP Add-On chart and
their default values.

### General parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `additionalLabels` | object | `{}` | Additional labels to be applied to installed resources. Note that not all resources will receive these labels. |
| `crds.install` | bool | `true` | Whether to install the `HTTPScaledObject` [`CustomResourceDefinition`](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) |
| `images.interceptor` | string | `"ghcr.io/kedacore/http-add-on-interceptor"` | Image name for the interceptor image component |
| `images.kubeRbacProxy.name` | string | `"gcr.io/kubebuilder/kube-rbac-proxy"` | Image name for the Kube RBAC Proxy image component |
| `images.kubeRbacProxy.tag` | string | `"v0.13.0"` | Image tag for the Kube RBAC Proxy image component |
| `images.operator` | string | `"ghcr.io/kedacore/http-add-on-operator"` | Image name for the operator image component |
| `images.scaler` | string | `"ghcr.io/kedacore/http-add-on-scaler"` | Image name for the scaler image component |
| `images.tag` | string | `""` | Image tag for the http add on. This tag is applied to the images listed in `images.operator`, `images.interceptor`, and `images.scaler`. Optional, given app version of Helm chart is used by default |
| `rbac.aggregateToDefaultRoles` | bool | `false` | Install aggregate roles for edit and view |

### Operator

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `operator.affinity` | object | `{}` | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) |
| `operator.imagePullSecrets` | list | `[]` | The image pull secrets for the operator component |
| `operator.nodeSelector` | object | `{}` | Node selector for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) |
| `operator.port` | int | `8443` | The port for the operator main server to run on |
| `operator.pullPolicy` | string | `"Always"` | The image pull policy for the operator component |
| `operator.resources.limits` | object | `{"cpu":0.5,"memory":"64Mi"}` | The CPU/memory resource limit for the operator component |
| `operator.resources.requests` | object | `{"cpu":"250m","memory":"20Mi"}` | The CPU/memory resource request for the operator component |
| `operator.tolerations` | list | `[]` | Tolerations for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)) |
| `operator.watchNamespace` | string | `""` | The namespace to watch for new `HTTPScaledObject`s. Leave this blank (i.e. `""`) to tell the operator to watch all namespaces. |

### Scaler

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `scaler.affinity` | object | `{}` | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) |
| `scaler.grpcPort` | int | `9090` | The port for the scaler's gRPC server. This is the server that KEDA will send scaling requests to. |
| `scaler.healthPort` | int | `9091` | The port for the scaler's health check and admin server |
| `scaler.imagePullSecrets` | list | `[]` | The image pull secrets for the scaler component |
| `scaler.nodeSelector` | object | `{}` | Node selector for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) |
| `scaler.pendingRequestsInterceptor` | int | `200` | The number of "target requests" that the external scaler will report to KEDA for the interceptor's scaling metrics. See the [KEDA external scaler documentation](https://keda.sh/docs/2.4/concepts/external-scalers/) for details on target requests. |
| `scaler.pullPolicy` | string | `"Always"` | The image pull policy for the scaler component |
| `scaler.resources.limits.cpu` | float | `0.5` |  |
| `scaler.resources.limits.memory` | string | `"64Mi"` |  |
| `scaler.resources.requests.cpu` | string | `"250m"` |  |
| `scaler.resources.requests.memory` | string | `"20Mi"` |  |
| `scaler.service` | string | `"external-scaler"` | The name of the Kubernetes `Service` for the scaler component |
| `scaler.tolerations` | list | `[]` | Tolerations for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)) |

### Interceptor

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `interceptor.admin.port` | int | `9090` | The port for the interceptor's admin server to run on |
| `interceptor.admin.service` | string | `"interceptor-admin"` | The name of the Kubernetes `Service` for the interceptor's admin service |
| `interceptor.affinity` | object | `{}` | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) |
| `interceptor.deploymentCachePollingIntervalMS` | int | `250` | How often (in milliseconds) the interceptor does a full refresh of its deployment cache. The interceptor will also use Kubernetes events to stay up-to-date with the deployment cache changes. This duration is the maximum time it will take to see changes to the deployment state. |
| `interceptor.expectContinueTimeout` | string | `"1s"` | Special handling for responses with "Expect: 100-continue" response headers. see https://pkg.go.dev/net/http#Transport under the 'ExpectContinueTimeout' field for more details |
| `interceptor.forceHTTP2` | bool | `false` | Whether or not the interceptor should force requests to use HTTP/2 |
| `interceptor.idleConnTimeout` | string | `"90s"` | The timeout after which any idle connection is closed and removed from the interceptor's in-memory connection pool. |
| `interceptor.imagePullSecrets` | list | `[]` | The image pull secrets for the interceptor component |
| `interceptor.keepAlive` | string | `"1s"` | The interceptor's connection keep alive timeout |
| `interceptor.maxIdleConns` | int | `100` | The maximum number of idle connections allowed in the interceptor's in-memory connection pool. Set to 0 to indicate no limit |
| `interceptor.nodeSelector` | object | `{}` | Node selector for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) |
| `interceptor.proxy.port` | int | `8080` | The port on which the interceptor's proxy service will listen for live HTTP traffic |
| `interceptor.proxy.service` | string | `"interceptor-proxy"` | The name of the Kubernetes `Service` for the interceptor's proxy service. This is the service that accepts live HTTP traffic. |
| `interceptor.pullPolicy` | string | `"Always"` | The image pull policy for the interceptor component |
| `interceptor.replicas.max` | int | `50` | The maximum number of interceptor replicas that should ever be running |
| `interceptor.replicas.min` | int | `3` | The minimum number of interceptor replicas that should ever be running |
| `interceptor.replicas.waitTimeout` | string | `"20s"` | The maximum time the interceptor should wait for an HTTP request to reach a backend before it is considered a failure |
| `interceptor.resources.limits` | object | `{"cpu":0.5,"memory":"64Mi"}` | The CPU/memory resource limit for the operator component |
| `interceptor.resources.requests` | object | `{"cpu":"250m","memory":"20Mi"}` | The CPU/memory resource request for the operator component |
| `interceptor.responseHeaderTimeout` | string | `"500ms"` | How long the interceptor will wait between forwarding a request to a backend and receiving response headers back before failing the request |
| `interceptor.scaledObject.pollingInterval` | int | `1` | The interval (in milliseconds) that KEDA should poll the external scaler to fetch scaling metrics about the interceptor |
| `interceptor.tcpConnectTimeout` | string | `"500ms"` | How long the interceptor waits to establish TCP connections with backends before failing a request. |
| `interceptor.tlsHandshakeTimeout` | string | `"10s"` | The maximum amount of time the interceptor will wait for a TLS handshake. Set to zero to indicate no timeout. |
| `interceptor.tolerations` | list | `[]` | Tolerations for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)) |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example:

```console
$ helm install http-add-on kedacore/keda-add-ons-http --namespace keda \
               --set version=<different tag from app version>
```

Alternatively, a YAML file that specifies the values for the above parameters can
be provided while installing the chart. For example,

```console
helm install http-add-on kedacore/keda-add-ons-http --namespace keda -f values.yaml
```

----------------------------------------------
Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs)
