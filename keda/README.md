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

The following table lists the configurable parameters of the KEDA chart and
their default values.

| Parameter                                                  | Description                               | Default                                         |
|:-----------------------------------------------------------|:------------------------------------------|:------------------------------------------------|
| `image.keda.repository`                                    | Image name of KEDA operator               | `ghcr.io/kedacore/keda` |
| `image.keda.tag`                                           | Image tag of KEDA operator. Optional, given app version of Helm chart is used by default | `` |
| `image.metricsApiServer.repository`                        | Image name of KEDA Metrics API Server        | `ghcr.io/kedacore/keda-metrics-apiserver` |
| `image.metricsApiServer.tag`                               | Image tag of KEDA Metrics API Server. Optional, given app version of Helm chart is used by default | `` |
| `image.webhooks.repository`                                | Image name of KEDA admission-webhooks               | `ghcr.io/kedacore/keda-admission-webhooks` |
| `image.webhooks.tag`                                       | Image tag of KEDA admission-webhooks . Optional, given app version of Helm chart is used by default | `` |
| `crds.install`                               | Defines whether the KEDA CRDs have to be installed or not. | `true`                 |
| `watchNamespace`                                           | Defines Kubernetes namespaces to watch to scale their workloads. Default watches all namespaces | `` |
| `operator.name`                                            | Name of the KEDA operator | `keda-operator` |
| `operator.replicaCount`                                      | Capability to configure the number of replicas for KEDA operator.<br /><br />While you can run more replicas of our operator, only one operator instance will be the leader and serving traffic.<br /><br />You can run multiple replicas, but they will not improve the performance of KEDA, it could only reduce downtime during a failover.<br /><br />Learn more in [our documentation](https://keda.sh/docs/latest/operate/cluster/#high-availability).| `1` |
| `operator.affinity`                                        | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) for KEDA operator. Takes precedence over the `affinity` field | `{}` |
| `metricsServer.replicaCount`                                      | Capability to configure the number of replicas for KEDA metric server.<br /><br />While you can run more replicas of our metric server, only one instance will used and serve traffic.<br /><br />You can run multiple replicas, but they will not improve the performance of KEDA, it could only reduce downtime during a failover.<br /><br /> Learn more in [our documentation](https://keda.sh/docs/latest/operate/cluster/#high-availability).| `1` |
| `metricsServer.dnsPolicy`                                  | Defined the DNS policy for the metric server | `ClusterFirst`
| `metricsServer.useHostNetwork`                             | Enable metric server to use host network  | `false`
| `metricsServer.affinity`                                   | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) for Metrics API Server. Takes precedence over the `affinity` field | `{}` |
| `webhooks.enable`                                           | Enable admission webhooks (this feature option will be removed in v2.12) | `true` |
| `webhooks.name`                                             | Name of the KEDA admission webhooks | `keda-admission-webhooks` |
| `webhooks.replicaCount`                                      | Capability to configure the number of replicas for KEDA admission webhooks | `1` |
| `webhooks.affinity`                                        | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) for KEDA admission webhooks. Takes precedence over the `affinity` field | `{}` |
| `webhooks.failurePolicy`                                     | [Failure policy](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#failure-policy) to use with KEDA admission webhooks | `Ignore` |
| `imagePullSecrets`                                         | Name of secret to use to pull images to use to pull Docker images | `[]` |
| `additionalLabels`                                         | Additional labels to apply to KEDA workloads | `{}` |
| `additionalAnnotations`                                    | Additional annotations to apply to KEDA workloads | `{}` |
| `podAnnotations.keda`                                      | Pod annotations for KEDA operator | `{}` |
| `podAnnotations.metricsAdapter`                            | Pod annotations for KEDA Metrics Adapter | `{}` |
| `podAnnotations.webhooks`                                  | Pod annotations for KEDA Admission webhooks | `{}` |
| `upgradeStrategy.operator`                                 | Capability to configure [Deployment upgrade strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) for operator      | `{}` |
| `upgradeStrategy.metricsApiServer`                         | Capability to configure [Deployment upgrade strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) for Metrics Api Server      | `{}` |
| `upgradeStrategy.webhooks`                                 | Capability to configure [Deployment upgrade strategy](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy) for Admission webhooks      | `{}` |
| `podDisruptionBudget.operator`                                      | Capability to configure [Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)       | `{}` |
| `podDisruptionBudget.metricServer`                                      | Capability to configure [Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)       | `{}` |
| `podDisruptionBudget.webhooks`                                      | Capability to configure [Pod Disruption Budget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)       | `{}` |
| `podLabels.keda`                                           | Pod labels for KEDA operator | `{}` |
| `podLabels.metricsAdapter`                                 | Pod labels for KEDA Metrics Adapter | `{}` |
| `podLabels.webhooks`                                       | Pod labels for KEDA Admission webhooks | `{}` |
| `rbac.create`                                              | Specifies whether RBAC should be used | `true`                                        |
| `serviceAccount.create`                                    | Specifies whether a service account should be created       | `true`                                        |
| `serviceAccount.name`                                      | The name of the service account to use. If not set and create is true, a name is generated.      | `keda-operator` |
| `serviceAccount.automountServiceAccountToken`              | Specifies whether created service account should automount API-Credentials | `true` |
| `serviceAccount.annotations`                               | Annotations to add to the service account | `{}` |
| `podIdentity.activeDirectory.identity`                     | Identity in Azure Active Directory to use for Azure pod identity | `` |
| `podIdentity.azureWorkload.clientId`                       | Id of Azure Active Directory Client to use for authentication with Azure Workload Identity. ([docs](https://keda.sh/docs/concepts/authentication/#azure-workload-identity)) | `` |
| `podIdentity.azureWorkload.enabled`                        | Specifies whether [Azure Workload Identity](https://azure.github.io/azure-workload-identity/) is to be enabled or not. ([docs](https://keda.sh/docs/concepts/authentication/#azure-workload-identity)) | `false` |
| `podIdentity.azureWorkload.tenantId`                       | Id Azure Active Directory Tenant to use for authentication with for Azure Workload Identity. ([docs](https://keda.sh/docs/concepts/authentication/#azure-workload-identity)) | `` |
| `podIdentity.azureWorkload.tokenExpiration`                | Duration in seconds to automatically expire tokens for the service account. ([docs](https://keda.sh/docs/concepts/authentication/#azure-workload-identity)) | `3600` |
| `podIdentity.aws.irsa.audience`                            | Sets the token audience for IRSA. | `sts.amazonaws.com` |
| `podIdentity.aws.irsa.enabled`                             | Specifies whether [AWS IAM Roles for Service Accounts (IRSA)](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) is to be enabled or not. | `false` |
| `podIdentity.aws.irsa.roleArn`                             | ARN of an IRSA IAM role with a web identity provider to use for authentication via STS. | `` |
| `podIdentity.aws.irsa.stsRegionalEndpoints`                | Sets the use of an STS regional endpoint instead of global. Recommended to use regional endpoint in almost all cases. | `true` |
| `podIdentity.aws.irsa.tokenExpiration`                     | Duration in seconds to automatically expire tokens for the service account. | `86400` |
| `grpcTLSCertsSecret`                                       | Name of the secret that will be mounted to the /grpccerts path on the Pod to communicate over TLS with external scaler(s) (recommended).  | ``|
| `hashiCorpVaultTLS`                                        | Name of the secret that will be mounted to the /vault path on the Pod to communicate over TLS with HashiCorp Vault (recommended). | `` |
| `logging.operator.level`                                   | Logging level for KEDA Operator. Allowed values are 'debug', 'info' & 'error'. | `info`                                        |
| `logging.operator.format`                                  | Logging format for KEDA Operator. Allowed values are 'console' & 'json'. | `console`                                        |
| `logging.operator.timeEncoding`                            | Logging time format for KEDA Operator. Allowed values are 'epoch', 'millis', 'nano', 'iso8601', 'rfc3339' or 'rfc3339nano'. | `rfc3339` |
| `logging.metricServer.level`                               | Logging level for Metrics Server.Policy to use to pull Docker images. Allowed values are '0' for info, '4' for debug, or an integer value greater than 0, specified as string. You can find all allowed options [here](https://github.com/kubernetes/klog/blob/main/internal/severity/severity.go#L30). | `0` |
| `logging.webhooks.level`                                   | Logging level for KEDA Admission webhooks. Allowed values are 'debug', 'info' & 'error'. | `info` |
| `logging.webhooks.format`                                  | Logging format for KEDA Admission webhooks. Allowed values are 'console' & 'json'. | `console`                                        |
| `logging.webhooks.timeEncoding`                            | Logging time format for KEDA Admission webhooks. Allowed values are 'epoch', 'millis', 'nano', 'iso8601', 'rfc3339' or 'rfc3339nano'. | `rfc3339` |
| `securityContext`                                          | Security context for all containers ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)) | [See below](#KEDA-is-secure-by-default) |
| `securityContext.operator`                                 | Security context of the operator container ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)) | [See below](#KEDA-is-secure-by-default) |
| `securityContext.metricServer`                             | Security context of the metricServer container ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)) | [See below](#KEDA-is-secure-by-default) |
| `securityContext.webhooks`                             | Security context of the admission webhooks container ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container)) | [See below](#KEDA-is-secure-by-default) |
| `podSecurityContext`                                       | Pod security context for all pods ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | [See below](#KEDA-is-secure-by-default) |
| `podSecurityContext.operator`                              | Pod security context of the KEDA operator pod ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | [See below](#KEDA-is-secure-by-default) |
| `podSecurityContext.metricServer`                          | Pod security context of the KEDA metrics apiserver pod ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | [See below](#KEDA-is-secure-by-default) |
| `podSecurityContext.webhooks`                          | Pod security context of the KEDA admission webhooks pod ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)) | [See below](#KEDA-is-secure-by-default) |
| `resources`                                                | Manage resource request & limits of all KEDA workloads ([docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)) | `{}` |
| `resources.operator`                                       | Manage resource request & limits of KEDA operator pod ([docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)) | `` |
| `resources.metricServer`                                   | Manage resource request & limits of KEDA metrics apiserver pod ([docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)) | `` |
| `resources.webhooks`                                   | Manage resource request & limits of KEDA admission webhooks pod ([docs](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)) | `` |
| `nodeSelector`                                             | Node selector for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)) | `{}` |
| `tolerations`                                              | Tolerations for pod scheduling ([docs](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)) | `[]` |
| `topologySpreadConstraints.operator` | object | `{}` | Pod Topology Constraints of KEDA operator pod https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ |
| `topologySpreadConstraints.metricsServer` | object | `{}` | Pod Topology Constraints of KEDA metrics apiserver pod https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ |
| `topologySpreadConstraints.webhooks` | object | `{}` | Pod Topology Constraints of KEDA admission webhooks pod https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ |
| `affinity`                                                 | Affinity for pod scheduling ([docs](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/)) for both KEDA operator and Metrics API Server | `{}` |
| `priorityClassName`                                        | Pod priority for KEDA Operator and Metrics Adapter ([docs](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/)) | `` |
| `extraArgs.keda`                                           | Additional KEDA Operator container arguments| `{}` |
| `extraArgs.metricsAdapter`                                 | Additional Metrics Adapter container arguments | `{}` |
| `env`                                                      | Additional environment variables that will be passed onto KEDA operator and metrics api service | `` |
| `http.timeout` | The default HTTP timeout to use for all scalers that use raw HTTP clients (some scalers use SDKs to access target services. These have built-in HTTP clients, and the timeout does not necessarily apply to them) | `` |
| `service.annotations`                                      | Annotations to add the KEDA Metric Server service | `{}` |
| `service.portHttp`                                         | Service HTTP port for KEDA Metric Server service | `80` |
| `service.portHttpTarget`                                   | Service HTTP port for KEDA Metric Server container | `8080` |
| `service.portHttps`                                        | HTTPS port for KEDA Metric Server service | `443` |
| `service.portHttpsTarget`                                  | HTTPS port for KEDA Metric Server container | `6443` |
| `prometheus.metricServer.enabled`                          | Enable metric server Prometheus metrics expose | `false` |
| `prometheus.metricServer.port`                             | HTTP port used for exposing metrics server prometheus metrics | `9022` |
| `prometheus.metricServer.portName`                         | HTTP port name for exposing metrics server prometheus metrics | `metrics` |
| `prometheus.metricServer.path`                             | Path used for exposing metric server prometheus metrics | `/metrics` |
| `prometheus.metricServer.podMonitor.enabled`               | Enable monitoring for metric server using podMonitor crd (prometheus operator) | `false` |
| `prometheus.metricServer.podMonitor.interval`              | Scraping interval for metric server using podMonitor crd (prometheus operator) | `` |
| `prometheus.metricServer.podMonitor.scrapeTimeout`         | Scraping timeout for metric server using podMonitor crd (prometheus operator) | `` |
| `prometheus.metricServer.podMonitor.namespace`             | Scraping namespace for metric server using podMonitor crd (prometheus operator) | `` |
| `prometheus.metricServer.podMonitor.additionalLabels`      | Additional labels to add for metric server using podMonitor crd (prometheus operator) | `{}` |
| `prometheus.metricServer.podMonitor.relabelings`           | List of expressions that define custom relabeling rules for metric server podMonitor crd (prometheus operator) | `[]` |
| `prometheus.metricServer.serviceMonitor.enabled`           | Enable monitoring for metric server using podMonitor crd (prometheus operator) | `false` |
| `prometheus.metricServer.serviceMonitor.jobLabel`         | JobLabel selects the label from the associated Kubernetes service which will be used as the job label for all metrics. [ServiceMonitor Spec](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) | `` |
| `prometheus.metricServer.serviceMonitor.targetLabels`         | TargetLabels transfers labels from the Kubernetes `Service` onto the created metrics | `[]` |
| `prometheus.metricServer.serviceMonitor.podTargetLabels`        | PodTargetLabels transfers labels on the Kubernetes `Pod` onto the created metrics | `[]` |
| `prometheus.metricServer.serviceMonitor.port`         | Name of the service port this endpoint refers to. Mutually exclusive with targetPort | `metrics` |
| `prometheus.metricServer.serviceMonitor.targetPort`         | Name or number of the target port of the Pod behind the Service, the port must be specified with container port property. Mutually exclusive with port | `` |
| `prometheus.metricServer.serviceMonitor.interval`         | Interval at which metrics should be scraped If not specified Prometheus’ global scrape interval is used. | `` |
| `prometheus.metricServer.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended If not specified, the Prometheus global scrape timeout is used unless it is less than Interval in which the latter is used | `` |
| `prometheus.metricServer.serviceMonitor.relabellings`         | List of expressions that define custom relabeling rules for metric server ServiceMonitor crd (prometheus operator). [RelabelConfig Spec](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.RelabelConfig) | `[]` |
| `prometheus.metricServer.serviceMonitor.additionalLabels`         | Additional labels to add for metric server using ServiceMonitor crd (prometheus operator) | `{}` |
| `prometheus.operator.enabled`                              | Enable KEDA Operator prometheus metrics expose | `false` |
| `prometheus.operator.port`                                 | Port used for exposing KEDA Operator prometheus metrics | `8080` |
| `prometheus.operator.podMonitor.enabled`                   | Enable monitoring for KEDA Operator using podMonitor crd (prometheus operator) | `false` |
| `prometheus.operator.podMonitor.interval`                  | Scraping interval for KEDA Operator using podMonitor crd (prometheus operator) | `` |
| `prometheus.operator.podMonitor.scrapeTimeout`             | Scraping timeout for KEDA Operator using podMonitor crd (prometheus operator) | `` |
| `prometheus.operator.podMonitor.namespace`                 | Scraping namespace for KEDA Operator using podMonitor crd (prometheus operator) | `` |
| `prometheus.operator.podMonitor.additionalLabels`          | Additional labels to add for KEDA Operator using podMonitor crd (prometheus operator) | `{}` |
| `prometheus.operator.serviceMonitor.enabled`           | Enable monitoring for metric server using podMonitor crd (prometheus operator) | `false` |
| `prometheus.operator.serviceMonitor.jobLabel`         | JobLabel selects the label from the associated Kubernetes service which will be used as the job label for all metrics. [ServiceMonitor Spec](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) | `` |
| `prometheus.operator.serviceMonitor.targetLabels`         | TargetLabels transfers labels from the Kubernetes `Service` onto the created metrics | `[]` |
| `prometheus.operator.serviceMonitor.podTargetLabels`        | PodTargetLabels transfers labels on the Kubernetes `Pod` onto the created metrics | `[]` |
| `prometheus.operator.serviceMonitor.port`         | Name of the service port this endpoint refers to. Mutually exclusive with targetPort | `metrics` |
| `prometheus.operator.serviceMonitor.targetPort`         | Name or number of the target port of the Pod behind the Service, the port must be specified with container port property. Mutually exclusive with port | `` |
| `prometheus.operator.serviceMonitor.interval`         | Interval at which metrics should be scraped If not specified Prometheus’ global scrape interval is used. | `` |
| `prometheus.operator.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended If not specified, the Prometheus global scrape timeout is used unless it is less than Interval in which the latter is used | `` |
| `prometheus.operator.serviceMonitor.relabellings`         | List of expressions that define custom relabeling rules for metric server ServiceMonitor crd (prometheus operator). [RelabelConfig Spec](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.RelabelConfig) | `[]` |
| `prometheus.operator.serviceMonitor.additionalLabels`         | Additional labels to add for metric server using ServiceMonitor crd (prometheus operator) | `{}` |
| `prometheus.operator.prometheusRules.enabled`              | Enable monitoring for KEDA Operator using prometheusRules crd (prometheus operator) | `false` |
| `prometheus.operator.prometheusRules.namespace`            | Scraping namespace for KEDA Operator using prometheusRules crd (prometheus operator) | `` |
| `prometheus.operator.prometheusRules.additionalLabels`     | Additional labels to add for KEDA Operator using prometheusRules crd (prometheus operator) | `{}` |
| `prometheus.operator.prometheusRules.alerts`               | Additional alerts to add for KEDA Operator using prometheusRules crd (prometheus operator) | `[]` |
| `prometheus.operator.podMonitor.relabelings`               | List of expressions that define custom relabeling rules for KEDA Operator podMonitor crd (prometheus operator) | `[]` |
| `prometheus.webhooks.enabled`                              | Enable KEDA admission webhooks prometheus metrics expose | `false` |
| `prometheus.webhooks.port`                                 | Port used for exposing KEDA admission webhooks prometheus metrics | `8080` |
| `prometheus.webhooks.serviceMonitor.enabled`           | Enable monitoring for metric server using serviceMonitor crd (prometheus operator) | `false` |
| `prometheus.webhooks.serviceMonitor.jobLabel`         | JobLabel selects the label from the associated Kubernetes service which will be used as the job label for all metrics. [ServiceMonitor Spec](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) | `` |
| `prometheus.webhooks.serviceMonitor.targetLabels`         | TargetLabels transfers labels from the Kubernetes `Service` onto the created metrics | `[]` |
| `prometheus.webhooks.serviceMonitor.podTargetLabels`        | PodTargetLabels transfers labels on the Kubernetes `Pod` onto the created metrics | `[]` |
| `prometheus.webhooks.serviceMonitor.port`         | Name of the service port this endpoint refers to. Mutually exclusive with targetPort | `metrics` |
| `prometheus.webhooks.serviceMonitor.targetPort`         | Name or number of the target port of the Pod behind the Service, the port must be specified with container port property. Mutually exclusive with port | `` |
| `prometheus.webhooks.serviceMonitor.interval`         | Interval at which metrics should be scraped If not specified Prometheus’ global scrape interval is used. | `` |
| `prometheus.webhooks.serviceMonitor.scrapeTimeout`        | Timeout after which the scrape is ended If not specified, the Prometheus global scrape timeout is used unless it is less than Interval in which the latter is used | `` |
| `prometheus.webhooks.serviceMonitor.relabellings`         | List of expressions that define custom relabeling rules for metric server ServiceMonitor crd (prometheus operator). [RelabelConfig Spec](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.RelabelConfig) | `[]` |
| `prometheus.webhooks.serviceMonitor.additionalLabels`         | Additional labels to add for metric server using ServiceMonitor crd (prometheus operator) | `{}` |
| `prometheus.webhooks.prometheusRules.enabled`              | Enable monitoring for KEDA admission webhooks using prometheusRules crd (prometheus operator) | `false` |
| `prometheus.webhooks.prometheusRules.namespace`            | Scraping namespace for KEDA admission webhooks using prometheusRules crd (prometheus operator) | `` |
| `prometheus.webhooks.prometheusRules.additionalLabels`     | Additional labels to add for KEDA admission webhooks using prometheusRules crd (prometheus operator) | `{}` |
| `prometheus.webhooks.prometheusRules.alerts`               | Additional alerts to add for KEDA admission webhooks using prometheusRules crd (prometheus operator) | `[]` |
| `volumes.keda.extraVolumes`                                | Extra volumes for KEDA deployment | `[]` |
| `volumes.keda.extraVolumeMounts`                           | Extra volume mounts for KEDA deployment | `[]` |
| `volumes.metricsApiServer.extraVolumes`                    | Extra volumes for metric server deployment | `[]` |
| `volumes.metricsApiServer.extraVolumeMounts`               | Extra volume mounts for metric server deployment | `[]` |
| `volumes.webhooks.extraVolumes`                            | Extra volumes for admission webhooks deployment | `[]` |
| `volumes.webhooks.extraVolumeMounts`                       | Extra volume mounts for admission webhooks deployment | `[]` |
| `certificates.autoGenerated`                               | Enables the self generation for KEDA TLS certificates | `true` |
| `certificates.secretName`                                  | Secret name to be mounted with KEDA TLS certificates | `kedaorg-certs` |
| `certificates.mountPath`                                   | Path where KEDA TLS certificates are mounted | `/certs` |

Specify each parameter using the `--set key=value[,key=value]` argument to
`helm install`. For example:

```console
$ helm install keda kedacore/keda --namespace keda \
               --set image.keda.tag=<different tag from app version> \
               --set image.metricsApiServer.tag=<different tag from app version> \
               --set image.webhooks.tag=<different tag from app version>
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
    seccompProfile:
      type: RuntimeDefault
  metricServer:
    capabilities:
      drop:
      - ALL
    allowPrivilegeEscalation: false
    ## Metrics server needs to write the self-signed cert. See FAQ for discussion of options.
    # readOnlyRootFilesystem: true
    seccompProfile:
      type: RuntimeDefault
  webhooks:
    capabilities:
      drop:
      - ALL
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    seccompProfile:
      type: RuntimeDefault

podSecurityContext:
  operator:
    runAsNonRoot: true
  metricServer:
    runAsNonRoot: true
  webhooks:
    runAsNonRoot: true
```
