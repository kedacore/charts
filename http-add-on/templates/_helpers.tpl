{{/* vim: set filetype=mustache: */}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "keda-http-add-on.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate match labels
*/}}
{{- define "keda-http-add-on.matchLabels" }}
app.kubernetes.io/part-of: {{ .Chart.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Generate basic labels
*/}}
{{- define "keda-http-add-on.labels" }}
{{- include "keda-http-add-on.matchLabels" . }}
app.kubernetes.io/version: {{ .Values.images.tag | default .Chart.AppVersion }}
helm.sh/chart: {{ include "keda-http-add-on.chart" . }}
{{- if .Values.additionalLabels }}
{{ toYaml .Values.additionalLabels }}
{{- end }}
{{- end }}
