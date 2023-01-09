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
We are a Cloud Native Computing Foundation (CNCF) incubation project.
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

The following table lists the configurable parameters of the HTTP Add-On chart and
their default values.

| Parameter                                                  | Description                               | Default                                         |
|:-----------------------------------------------------------|:------------------------------------------|:------------------------------------------------|
| `images.tag`                                               | Image tag for the http add on. This tag is applied to the images listed in `images.operator`, `images.interceptor`, and `images.scaler`             | None, it uses Helm chart's app version as a default                              |
| `images.operator`                                          | Image name for the operator image component | `ghcr.io/kedacore/http-add-on-operator:latest` |
| `images.interceptor`                                       | Image name for the interceptor image component | `ghcr.io/kedacore/http-add-on-interceptor:latest` |
| `images.scaler`                                            | Image name for the scaler image component | `ghcr.io/kedacore/http-add-on-scaler:latest` |
| `images.kubeRbacProxy.name`                                | Image name for the Kube RBAC Proxy image component | `gcr.io/kubebuilder/kube-rbac-proxy` |
| `images.kubeRbacProxy.tag`                                 | Image tag for the Kube RBAC Proxy image component | `v0.5.0` |
| `additionalLabels`                                         | Additional labels to be applied to installed resources. Note that not all resources will receive these labels. | Nothing |
| `crds.install`                                             | Whether to install the `HTTPScaledObject` [`CustomResourceDefinition`](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) | `true` |
| `operator.watchNamespace`                                  | The namespace to watch for new `HTTPScaledObject`s. Leave this blank (i.e. `""`) to tell the operator to watch all namespaces. | `""` |
| `operator.pullPolicy`                                      | The image pull policy for the operator component | `Always` |
| `operator.imagePullSecrets`                                | The image pull secrets for the operator component | `[]` |
| `operator.resources.limits.cpu`                            | The CPU resource limit for the operator component | `0.5` |
| `operator.resources.limits.memory`                         | The memory resource limit for the operator component | `64Mi` |
| `operator.resources.requests.cpu`                          | The CPU resource request for the operator component | `250m` |
| `operator.resources.requests.memory`                       | The memory resource request for the operator component | `20Mi` |
| `operator.port`                                            | The port for the operator main server to run on | `8443` |
| `operator.adminService`                                    | The name of the [`Service`](https://kubernetes.io/docs/concepts/services-networking/service/) for the operator's admin server | `operator-admin` |
| `operator.adminPort`                                       | The port for the operator's admin server to run on | `9090` |
| `operator.nodeSelector`                                    | Node selector for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) | `{}` |
| `operator.tolerations`                                     | Tolerations for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)) | `{}` |
| `operator.affinity`                                        | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) | `{}` |
| `scaler.service`                                           | The name of the Kubernetes `Service` for the scaler component | `external-scaler` |
| `scaler.pullPolicy`                                        | The image pull policy for the scaler component | `Always` |
| `scaler.imagePullSecrets`                                  | The image pull secrets for the scaler component | `[]` |
| `scaler.grpcPort`                                          | The port for the scaler's gRPC server. This is the server that KEDA will send scaling requests to. | `9090` |
| `scaler.healthPort`                                        | The port for the scaler's health check and admin server | `9091` |
| `scaler.pendingRequestsInterceptor`                        | The number of "target requests" that the external scaler will report to KEDA for the interceptor's scaling metrics. See the [KEDA external scaler documentation](https://keda.sh/docs/2.4/concepts/external-scalers/) for details on target requests. | `200` |
| `scaler.nodeSelector`                                      | Node selector for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) | `{}` |
| `scaler.tolerations`                                       | Tolerations for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)) | `{}` |
| `scaler.affinity`                                          | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) | `{}` |
| `interceptor.imagePullSecrets`                             | The image pull secrets for the interceptor component | `[]` |
| `interceptor.pullPolicy` | The image pull policy for the interceptor component | `Always` |
| `interceptor.admin.service` | The name of the Kubernetes `Service` for the interceptor's admin service | `interceptor-admin` |
| `interceptor.admin.port` | The port for the interceptor's admin server to run on | `9090` |
| `interceptor.proxy.service` | The name of the Kubernetes `Service` for the interceptor's proxy service. This is the service that accepts live HTTP traffic. | `interceptor-proxy` |
| `interceptor.proxy.port` | The port on which the interceptor's proxy service will listen for live HTTP traffic | `8080` |
| `interceptor.replicas.min` | The minimum number of interceptor replicas that should ever be running | `3` |
| `interceptor.replicas.max` | The maximum number of interceptor replicas that should ever be running | `50` |
| `interceptor.replicas.waitTimeout` | The maximum time the interceptor should wait for an HTTP request to reach a backend before it is considered a failure | `1500ms` |
| `interceptor.scaledObject.pollingInterval` | The interval (in milliseconds) that KEDA should poll the external scaler to fetch scaling metrics about the interceptor | `1` |
| `interceptor.routingTableUpdateDurationMS` | How often (in milliseconds) each interceptor replica should update its in-memory routing table from the central routing table copy. The interceptor will also use Kubernetes events to stay up-to-date with routing table changes. This duration is the maximum time it will take to get a routing table update | `500` |
| `interceptor.tcpConnectTimeout` | How long the interceptor waits to establish TCP connections with backends before failing a request. | `500ms`
| `interceptor.keepAlive` | The interceptor's connection keep alive timeout | `1s` |
| `interceptor.responseHeaderTimeout` | How long the interceptor will wait between forwarding a request to a backend and receiving response headers back before failing the request | `500ms`
| `interceptor.deploymentCachePollingIntervalMS` | How often (in milliseconds) the interceptor does a full refresh of its deployment cache. The interceptor will also use Kubernetes events to stay up-to-date with the deployment cache changes. This duration is the maximum time it will take to see changes to the deployment state. | `250` |
| `interceptor.forceHTTP2` | Whether or not the interceptor should force requests to use HTTP/2 | `false` |
| `interceptor.maxIdleConns` | The maximum number of idle connections allowed in the interceptor's in-memory connection pool. Set to 0 to indicate no limit | `100` |
| `interceptor.idleConnTimeout` | The timeout after which any idle connection is closed and removed from the interceptor's in-memory connection pool. | `90s` |
| `interceptor.tlsHandshakeTimeout` | The maximum amount of time the interceptor will wait for a TLS handshake. Set to zero to indicate no timeout. | `10s` |
| `interceptor.expectContinueTimeout` | Special handling for responses with "Expect: 100-continue" response headers. see https://pkg.go.dev/net/http#Transport under the 'ExpectContinueTimeout' field for more details | `1s` |
| `interceptor.nodeSelector`                                 | Node selector for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) | `{}` |
| `interceptor.tolerations`                                  | Tolerations for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)) | `{}` |
| `interceptor.affinity`                                     | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) | `{}` |

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
