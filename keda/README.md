<p align="center"><img src="https://raw.githubusercontent.com/kedacore/keda/main/images/keda-logo-transparent.png" width="300"/></p>
<p style="font-size: 25px" align="center"><b>Kubernetes-based Event Driven Autoscaling</b></p>

KEDA allows for fine grained autoscaling (including to/from zero) for event driven Kubernetes workloads.  KEDA serves as a Kubernetes Metrics Server and allows users to define autoscaling rules using a dedicated Kubernetes custom resource definition.

KEDA can run on both the cloud and the edge, integrates natively with Kubernetes components such as the Horizontal Pod Autoscaler, and has no external dependencies.

---
<p align="center">
We are a Cloud Native Computing Foundation (CNCF) incubation project.

<img src="https://raw.githubusercontent.com/kedacore/keda/main/images/logo-cncf.svg" height="75px">
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

| Parameter                                                  | Description                               | Default                                         |
|:-----------------------------------------------------------|:------------------------------------------|:------------------------------------------------|
| `image.keda.repository`                                    | Image name of KEDA operator               | `ghcr.io/kedacore/keda`                |
| `image.keda.tag`                                           | Image tag of KEDA operator. Optional, given app version of Helm chart is used by default | `` |
| `image.metricsApiServer.repository`                        | Image name of KEDA Metrics API Server        | `ghcr.io/kedacore/keda-metrics-apiserver` |
| `image.metricsApiServer.tag`                               | Image tag of KEDA Metrics API Server. Optional, given app version of Helm chart is used by default | `` |
| `crds.install`                               | Defines whether the KEDA CRDs have to be installed or not. | `true`                 |
| `watchNamespace`                                           | Defines Kubernetes namespaces to watch to scale their workloads. Default watches all namespaces | `` |
| `operator.name`                                            | Name of the KEDA operator | `keda-operator` |
| `operator.replicaCount`                                      | Capability to configure the number of replicas for KEDA operator.<br /><br />While you can run more replicas of our operator, only one operator instance will be the leader and serving traffic.<br /><br />You can run multiple replicas, but they will not improve the performance of KEDA, it could only reduce downtime during a failover.| `1` |
| `metricsServer.dnsPolicy`                                  | Defined the DNS policy for the metric server | `ClusterFirst`
| `metricsServer.useHostNetwork`                             | Enable metric server to use host network  | `false`
| `imagePullSecrets`                                         | Name of secret to use to pull images to use to pull Docker images | `[]` |
| `additionalLabels`                                         | Additional labels to apply to KEDA workloads | `{}` |
| `podAnnotations.keda`                                      | Pod annotations for KEDA operator | `{}` |
| `podAnnotations.metricsAdapter`                            | Pod annotations for KEDA Metrics Adapter | `{}` |
| `podDisruptionBudget.operator`                                      | Capability to configure [Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)       | `{}` |
| `podDisruptionBudget.metricServer`                                      | Capability to configure [Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)       | `{}` |
| `podLabels.keda`                                           | Pod labels for KEDA operator | `{}` |
| `podLabels.metricsAdapter`                                 | Pod labels for KEDA Metrics Adapter | `{}` |
| `rbac.create`                                              | Specifies whether RBAC should be used | `true`                                        |
| `serviceAccount.create`                                    | Specifies whether a service account should be created       | `true`                                        |
| `serviceAccount.name`                                      | The name of the service account to use. If not set and create is true, a name is generated.      | `keda-operator` |
| `serviceAccount.annotations`                               | Annotations to add to the service account | `{}` |
| `podIdentity.activeDirectory.identity`                     | Identity in Azure Active Directory to use for Azure pod identity | `` |
| `podIdentity.azureWorkload.clientId`                       | Id of Azure Active Directory Client to use for authentication with Azure Workload Identity. ([docs](https://keda.sh/docs/concepts/authentication/#azure-workload-identity)) | `` |
| `podIdentity.azureWorkload.enabled`                        | Specifies whether [Azure Workload Identity](https://azure.github.io/azure-workload-identity/) is to be enabled or not. ([docs](https://keda.sh/docs/concepts/authentication/#azure-workload-identity)) | `false` |
| `podIdentity.azureWorkload.tenantId`                       | Id Azure Active Directory Tenant to use for authentication with for Azure Workload Identity. ([docs](https://keda.sh/docs/concepts/authentication/#azure-workload-identity)) | `` |
| `podIdentity.azureWorkload.tokenExpiration`                | Duration in seconds to automatically expire tokens for the service account. ([docs](https://keda.sh/docs/concepts/authentication/#azure-workload-identity)) | `3600` |
| `grpcTLSCertsSecret`                                       | Name of the secret that will be mounted to the /grpccerts path on the Pod to communicate over TLS with external scaler(s) (recommended).  | ``|
| `hashiCorpVaultTLS`                                        | Name of the secret that will be mounted to the /vault path on the Pod to communicate over TLS with HashiCorp Vault (recommended). | `` |
| `logging.operator.level`                                   | Logging level for KEDA Operator. Allowed values are 'debug', 'info' & 'error'. | `info`                                        |
| `logging.operator.format`                                  | Logging format for KEDA Operator. Allowed values are 'console' & 'json'. | `console`                                        |
| `logging.operator.timeFormat`                              | Logging time format for KEDA Operator. Allowed values are 'epoch', 'millis', 'nano', or 'iso8601'. | `epoch` |
| `logging.metricServer.level`                               | Logging level for Metrics Server.Policy to use to pull Docker images. Allowed values are '0' for info, '4' for debug, or an integer value greater than 0, specified as string | `0` |
| `securityContext`                                          | Security context for all containers ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)) | [See below](#KEDA-is-secure-by-default) |
| `securityContext.operator`                                 | Security context of the operator container ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)) | [See below](#KEDA-is-secure-by-default) |
| `securityContext.metricServer`                             | Security context of the metricServer container ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)) | [See below](#KEDA-is-secure-by-default) |
| `podSecurityContext`                                       | Pod security context for all pods ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | [See below](#KEDA-is-secure-by-default) |
| `podSecurityContext.operator`                              | Pod security context of the KEDA operator pod ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | [See below](#KEDA-is-secure-by-default) |
| `podSecurityContext.metricServer`                          | Pod security context of the KEDA metrics apiserver pod ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | [See below](#KEDA-is-secure-by-default) |
| `resources`                                                | Manage resource request & limits of all KEDA workloads ([docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)) | `{}` |
| `resources.operator`                                       | Manage resource request & limits of KEDA operator pod ([docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)) | `` |
| `resources.metricServer`                                   | Manage resource request & limits of KEDA metrics apiserver pod ([docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)) | `` |
| `nodeSelector`                                             | Node selector for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) | `{}` |
| `tolerations`                                              | Tolerations for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)) | `{}` |
| `affinity`                                                 | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) | `{}` |
| `priorityClassName`                                        | Pod priority for KEDA Operator and Metrics Adapter ([docs](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/)) | `` |
| `extraArgs.keda`                                           | Additional KEDA Operator container arguments| `{}` |
| `extraArgs.metricsAdapter`                                 | Additional Metrics Adapter container arguments | `{}` |
| `env`                                                      | Additional environment variables that will be passed onto KEDA operator and metrics api service | `` |
| `http.timeout` | The default HTTP timeout to use for all scalers that use raw HTTP clients (some scalers use SDKs to access target services. These have built-in HTTP clients, and the timeout does not necessarily apply to them) | `` |
| `service.annotations`                                      | Annotations to add the KEDA Metric Server service | `{}`                                        |
| `service.portHttp`                                         | Service HTTP port for KEDA Metric Server service | `80`                                        |
| `service.portHttpTarget`                                   | Service HTTP port for KEDA Metric Server container | `8080`                                        |
| `service.portHttps`                                        | HTTPS port for KEDA Metric Server service | `443`                                        |
| `service.portHttpsTarget`                                  | HTTPS port for KEDA Metric Server container | `6443`                                        |
| `prometheus.metricServer.enabled`                          | Enable metric server prometheus metrics expose | `false`
| `prometheus.metricServer.port`                             | HTTP port used for exposing metrics server prometheus metrics | `9022`
| `prometheus.metricServer.portName`                         | HTTP port name for exposing metrics server prometheus metrics | `metrics`
| `prometheus.metricServer.path`                             | Path used for exposing metric server prometheus metrics | `/metrics`
| `prometheus.metricServer.podMonitor.enabled`               | Enable monitoring for metric server using podMonitor crd (prometheus operator) | `false`
| `prometheus.metricServer.podMonitor.interval`              | Scraping interval for metric server using podMonitor crd (prometheus operator) | ``
| `prometheus.metricServer.podMonitor.scrapeTimeout`         | Scraping timeout for metric server using podMonitor crd (prometheus operator) | ``
| `prometheus.metricServer.podMonitor.namespace`             | Scraping namespace for metric server using podMonitor crd (prometheus operator) | ``
| `prometheus.metricServer.podMonitor.additionalLabels`      | Additional labels to add for metric server using podMonitor crd (prometheus operator) | `{}`
| `prometheus.operator.enabled`                              | Enable keda operator prometheus metrics expose | `false`
| `prometheus.operator.port`                                 | HTTP port used for exposing keda operator prometheus metrics | `9022`
| `prometheus.operator.path`                                 | Path used for exposing keda operator prometheus metrics | `/metrics`
| `prometheus.operator.podMonitor.enabled`                   | Enable monitoring for keda operator using podMonitor crd (prometheus operator) | `false`
| `prometheus.operator.podMonitor.interval`                  | Scraping interval for keda operator using podMonitor crd (prometheus operator) | ``
| `prometheus.operator.podMonitor.scrapeTimeout`             | Scraping timeout for keda operator using podMonitor crd (prometheus operator) | ``
| `prometheus.operator.podMonitor.namespace`                 | Scraping namespace for keda operator using podMonitor crd (prometheus operator) | ``
| `prometheus.operator.podMonitor.additionalLabels`          | Additional labels to add for keda operator using podMonitor crd (prometheus operator) | `{}`
| `prometheus.operator.prometheusRules.enabled`              | Enable monitoring for keda operator using prometheusRules crd (prometheus operator) | `false`
| `prometheus.operator.prometheusRules.namespace`            | Scraping namespace for keda operator using prometheusRules crd (prometheus operator) | ``
| `prometheus.operator.prometheusRules.additionalLabels`     | Additional labels to add for keda operator using prometheusRules crd (prometheus operator) | `{}`
| `prometheus.operator.prometheusRules.alerts`               | Additional alerts to add for keda operator using prometheusRules crd (prometheus operator) | `[]`
| `volumes.keda.extraVolumes`                                | Extra volumes for keda deployment | `[]`
| `volumes.keda.extraVolumeMounts`                           | Extra volume mounts for keda deployment | `[]`
| `volumes.metricsApiServer.extraVolumes`                    | Extra volumes for metric server deployment | `[]`
| `volumes.metricsApiServer.extraVolumeMounts`               | Extra volume mounts for metric server deployment | `[]`

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example:

```console
$ helm install keda kedacore/keda --namespace keda \
               --set image.keda.tag=<different tag from app version>
               --set image.metricsApiServer.tag=<different tag from app version>
```

Alternatively, a YAML file that specifies the values for the above parameters can
be provided while installing the chart. For example,

```console
helm install keda kedacore/keda --namespace keda -f values.yaml
```

## KEDA is secure by default

Our default configuration strives to be as secure as possible. Because of that, KEDA will run as non-root and be secure-by-default:
```yaml
securityContext:
  operator:
    capabilities:
      drop:
      - ALL
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
  metricServer:
    capabilities:
      drop:
      - ALL
    allowPrivilegeEscalation: false
    ## Metrics server needs to write the self-signed cert so it's not possible set this
    # readOnlyRootFilesystem: true

podSecurityContext:
  operator:
    runAsNonRoot: true
  metricServer:
    runAsNonRoot: true
```