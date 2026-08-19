{{/* vim: set filetype=mustache: */}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "external-scaler-azure-cosmos-db.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
These labels will be applied to all Cosmos DB scaler resources in the chart.
*/}}
{{- define "external-scaler-azure-cosmos-db.labels" }}
helm.sh/chart: {{ include "external-scaler-azure-cosmos-db.chart" . }}
app: {{ .Chart.Name }}
control-plane: external-scaler
keda.sh/addon: {{ .Chart.Name }}
name: {{ .Chart.Name }}
app.kubernetes.io/component: external-scaler
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/part-of: {{ .Chart.Name }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion }}
{{- with .Values.additionalLabels }}
{{ . | toYaml }}
{{- end }}
{{- end }}

{{/*
Name of the service account to use.
When serviceAccount.create is false and no name is given, fall back to the namespace's
"default" service account rather than referencing one that does not exist.
*/}}
{{- define "external-scaler-azure-cosmos-db.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default .Chart.Name .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
