{{- define "keda.serviceAccountTokens" -}}
{{- $tokens := .Values.operator.serviceAccountTokens | default dict -}}
{{- mustToJson (mergeOverwrite (dict "mode" "enforce-audience" "additionalAllowedAudiences" (list)) (deepCopy $tokens)) -}}
{{- end -}}

{{/* Approve audiences and map named service accounts to minting audiences. */}}
{{- define "keda.serviceAccountTokenAudiences" -}}
{{- $tokens := include "keda.serviceAccountTokens" . | fromJson -}}
{{- $vault := include "keda.vaultAuth" . | fromJson -}}
{{- $allowed := $tokens.additionalAllowedAudiences -}}
{{- if $vault.audience -}}
  {{- $allowed = prepend $allowed $vault.audience -}}
{{- end -}}
{{- $entries := list -}}
{{- range (uniq $allowed) -}}
  {{- $entries = append $entries (dict "audience" .) -}}
{{- end -}}
{{- range .Values.permissions.operator.restrict.serviceAccountTokenCreationRoles -}}
  {{- if hasKey . "audience" -}}
    {{- $entries = append $entries (dict "serviceAccountName" .name "namespace" .namespace "audience" .audience) -}}
  {{- end -}}
{{- end -}}
{{- mustToJson $entries -}}
{{- end -}}

{{- define "keda.validateServiceAccountTokens" -}}
{{- $tokens := include "keda.serviceAccountTokens" . | fromJson -}}
{{- $entries := include "keda.serviceAccountTokenAudiences" . | fromJsonArray -}}
{{- $args := .Values.extraArgs.keda -}}
{{- if hasKey $args "service-account-token-mode" -}}
  {{- fail "set operator.serviceAccountTokens.mode instead of extraArgs.keda.service-account-token-mode" -}}
{{- end -}}
{{- range $flag := list "service-account-token-allowed-audiences" "vault-kubernetes-auth-token-mode" "vault-kubernetes-auth-default-audience" "vault-kubernetes-auth-additional-allowed-audience" -}}
  {{- if hasKey $args $flag -}}
    {{- fail (printf "%s was replaced by operator.serviceAccountTokens and hashiCorpVault.kubernetesAuth" $flag) -}}
  {{- end -}}
{{- end -}}
{{- if and (eq $tokens.mode "legacy") $entries -}}
  {{- fail "legacy token mode cannot be combined with configured audiences; remove Vault audience, additionalAllowedAudiences and minting audiences" -}}
{{- end -}}
{{- $seen := dict -}}
{{- range $entries -}}
  {{- if or (empty .audience) (ne .audience (trim .audience)) -}}
    {{- fail "service account token audiences must be nonempty and contain no surrounding whitespace" -}}
  {{- end -}}
  {{- if hasKey . "serviceAccountName" -}}
    {{- $key := printf "%s/%s" .namespace .serviceAccountName -}}
    {{- if hasKey $seen $key -}}
      {{- fail (printf "duplicate service account token audience mapping for %s" $key) -}}
    {{- end -}}
    {{- $_ := set $seen $key true -}}
  {{- end -}}
{{- end -}}
{{- if gt (len (mustToJson $entries)) 65536 -}}
  {{- fail "service account token audience configuration exceeds the chart's 64 KiB environment-value limit" -}}
{{- end -}}
{{- range (concat (.Values.env | default list) (.Values.operator.env | default list)) -}}
  {{- if eq .name "KEDA_SERVICE_ACCOUNT_TOKEN_AUDIENCES" -}}
    {{- if eq $tokens.mode "legacy" -}}
      {{- fail "remove KEDA_SERVICE_ACCOUNT_TOKEN_AUDIENCES when selecting legacy token mode" -}}
    {{- end -}}
    {{- if $entries -}}
      {{- fail "configure service account token audiences through chart values or env, not both" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}
