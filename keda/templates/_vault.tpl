{{- define "keda.vaultAuth" -}}
{{/* Support missing keys from --reuse-values; keep null mount paths disabled. */}}
{{- $auth := ((.Values.hashiCorpVault | default dict).kubernetesAuth | default dict) -}}
{{- mustToJson (mergeOverwrite (dict "audience" "") (deepCopy $auth)) -}}
{{- end -}}

{{/* Hash audiences to produce valid volume names. */}}
{{- define "keda.vaultVolumeName" -}}
{{- printf "keda-vault-%s" (. | sha256sum | trunc 16) -}}
{{- end -}}

{{/* An empty mount path disables projection, not audience approval. */}}
{{- define "keda.vaultProjections" -}}
{{- $auth := include "keda.vaultAuth" . | fromJson -}}
{{- $projections := list -}}
{{- if and $auth.audience $auth.projectedTokenMountPath -}}
  {{- $projections = append $projections (dict "audience" $auth.audience "projectedTokenMountPath" $auth.projectedTokenMountPath) -}}
{{- end -}}
{{- mustToJson $projections -}}
{{- end -}}

{{- define "keda.validateVault" -}}
{{- if hasKey .Values "vault" -}}
  {{- fail "vault has been renamed to hashiCorpVault; update your chart values" -}}
{{- end -}}
{{- $auth := include "keda.vaultAuth" . | fromJson -}}
{{- if and $auth.audience (hasKey .Values.extraArgs.keda "vault-kubernetes-auth-token-file") -}}
  {{- fail "configure the Vault token path through hashiCorpVault.kubernetesAuth or extraArgs.keda, not both" -}}
{{- end -}}
{{- if .Values.operator.outboundFilter -}}
  {{- if gt (len (mustToJson .Values.operator.outboundFilter)) 65536 -}}
    {{- fail "operator.outboundFilter exceeds the 64 KiB environment-value limit" -}}
  {{- end -}}
  {{- range (concat (.Values.env | default list) (.Values.operator.env | default list)) -}}
    {{- if eq .name "KEDA_OUTBOUND_FILTER" -}}
      {{- fail "configure KEDA_OUTBOUND_FILTER through operator.outboundFilter or env, not both" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{/* Validate generated mounts; extraVolumes are not automatically approved. */}}
{{- $names := dict "certificates" true "grpc-certs" true "hashicorp-vault-certs" true -}}
{{- range .Values.volumes.keda.extraVolumes -}}
  {{- $_ := set $names .name true -}}
{{- end -}}
{{- $paths := list .Values.certificates.mountPath "/var/run/secrets/kubernetes.io/serviceaccount" -}}
{{- if .Values.grpcTLSCertsSecret -}}{{- $paths = append $paths "/grpccerts" -}}{{- end -}}
{{- if .Values.hashiCorpVaultTLS -}}{{- $paths = append $paths "/hashicorp-vaultcerts" -}}{{- end -}}
{{- range .Values.volumes.keda.extraVolumeMounts -}}
  {{- $paths = append $paths .mountPath -}}
{{- end -}}
{{- range (include "keda.vaultProjections" . | fromJsonArray) -}}
  {{- $name := include "keda.vaultVolumeName" .audience -}}
  {{- if hasKey $names $name -}}
    {{- fail (printf "generated Vault volume %s collides with another volume; rename the conflicting extraVolume" $name) -}}
  {{- end -}}
  {{- $_ := set $names $name true -}}
  {{- $path := clean .projectedTokenMountPath -}}
  {{- if or (not (isAbs $path)) (eq $path "/") (ne $path .projectedTokenMountPath) -}}
    {{- fail "Vault projectedTokenMountPath must be a clean absolute directory path other than /" -}}
  {{- end -}}
  {{- range $paths -}}
    {{- $other := clean . -}}
    {{- if or (eq $path $other) (hasPrefix (printf "%s/" $path) $other) (hasPrefix (printf "%s/" (trimSuffix "/" $other)) $path) -}}
      {{- fail (printf "Vault projectedTokenMountPath %s overlaps another operator mount %s" $path $other) -}}
    {{- end -}}
  {{- end -}}
  {{- $paths = append $paths $path -}}
{{- end -}}
{{- end -}}
