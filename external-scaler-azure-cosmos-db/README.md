# KEDA External Scaler for Azure Cosmos DB

Chart for installing KEDA external scaler for Azure Cosmos DB.

- [Documentation](https://github.com/kedacore/external-scaler-azure-cosmos-db#readme)
- [Release Notes](https://github.com/kedacore/external-scaler-azure-cosmos-db/releases/tag/v0.1.0)
- [Example Usage](https://github.com/kedacore/external-scaler-azure-cosmos-db/tree/main/src/Scaler.Demo)

## Installation

1. Add and update Helm chart repo.

    ```shell
    helm repo add kedacore https://kedacore.github.io/charts
    helm repo update
    ```

1. Install KEDA Helm chart (*or follow one of the other installation methods on [KEDA documentation](https://keda.sh/docs/deploy)*).

    ```shell
    helm install keda kedacore/keda --namespace keda --create-namespace
    ```

1. Install Azure Cosmos DB external scaler Helm chart.

    ```shell
    helm install external-scaler-azure-cosmos-db kedacore/external-scaler-azure-cosmos-db --namespace keda --create-namespace
    ```

## Values

| Key | Type | Default | Description |
|---|---|---|---|
| additionalLabels | object | `{}` | Additional labels that should be applied to all resources |
| image.pullPolicy | string | `"Always"` | The image pull policy for Azure Cosmos DB external scaler |
| image.repository | string | `"ghcr.io/kedacore/external-scaler-azure-cosmos-db"` | The Docker image repository to use for Azure Cosmos DB external scaler |
| image.tag | string | `"0.1.0"` | The Docker image tag to use for Azure Cosmos DB external scaler |
| port | int | `4050` | The incoming port for 'Azure Cosmos DB external scaler' service |
| resources.limits.cpu | string | `"100m"` | Maximum limit on CPU for 'Azure Cosmos DB external scaler' pod |
| resources.limits.memory | string | `"512Mi"` | Maximum limit on memory for 'Azure Cosmos DB external scaler' pod |
| resources.requests.cpu | string | `"10m"` | Initial CPU request by 'Azure Cosmos DB external scaler' pod |
| resources.requests.memory | string | `"128Mi"` | Initial memory request by 'Azure Cosmos DB external scaler' pod |
