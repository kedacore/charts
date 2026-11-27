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

{{/* Map named service accounts to cloud workload identity federation audiences.
     Strictly isolated from keda.serviceAccountTokenAudiences (Vault and BSAT). */}}
{{- define "keda.cloudWorkloadIdentityAudiences" -}}
{{- $entries := list -}}
{{- range .Values.permissions.operator.restrict.cloudWorkloadIdentityTokenCreationRoles -}}
  {{- $entries = append $entries (dict "serviceAccountName" .name "namespace" .namespace "audience" .audience) -}}
{{- end -}}
{{- mustToJson $entries -}}
{{- end -}}

{{- define "keda.validateServiceAccountTokens" -}}
{{- $tokens := include "keda.serviceAccountTokens" . | fromJson -}}
{{- $entries := include "keda.serviceAccountTokenAudiences" . | fromJsonArray -}}
{{- $cloudEntries := include "keda.cloudWorkloadIdentityAudiences" . | fromJsonArray -}}
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
{{- if and (eq $tokens.mode "legacy") $cloudEntries -}}
  {{- fail "legacy token mode cannot be combined with cloud workload identity audiences; use enforce-audience or remove cloudWorkloadIdentityTokenCreationRoles" -}}
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
{{- $gcpWifPattern := "^(https:)?//iam\\.googleapis\\.com/projects/[0-9]+/locations/global/workloadIdentityPools/[a-z0-9-]+/providers/[a-z0-9-]+$" -}}
{{- $gkePoolPattern := "^identitynamespace:[a-z][a-z0-9-]{4,28}[a-z0-9]\\.svc\\.id\\.goog:https://container\\.googleapis\\.com/v1/projects/[a-z][a-z0-9-]{4,28}[a-z0-9]/locations/[a-z0-9-]+/clusters/[a-z](?:[a-z0-9-]{0,38}[a-z0-9])?$" -}}
{{- $seenCloud := dict -}}
{{- range $cloudEntries -}}
  {{- if or (empty .audience) (ne .audience (trim .audience)) -}}
    {{- fail "cloud workload identity audiences must be nonempty and contain no surrounding whitespace" -}}
  {{- end -}}
  {{- if not (or (regexMatch $gcpWifPattern .audience) (regexMatch $gkePoolPattern .audience)) -}}
    {{- fail (printf "unsupported cloud workload identity audience %q: expected a Google workload identity pool provider or a GKE identitynamespace audience" .audience) -}}
  {{- end -}}
  {{- $key := printf "%s/%s" .namespace .serviceAccountName -}}
  {{- if hasKey $seenCloud $key -}}
    {{- fail (printf "duplicate cloud workload identity audience mapping for %s" $key) -}}
  {{- end -}}
  {{- $_ := set $seenCloud $key true -}}
{{- end -}}
{{- if gt (len (mustToJson $cloudEntries)) 65536 -}}
  {{- fail "cloud workload identity audience configuration exceeds the chart's 64 KiB environment-value limit" -}}
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
  {{- if eq .name "KEDA_CLOUD_WORKLOAD_IDENTITY_AUDIENCES" -}}
    {{- if eq $tokens.mode "legacy" -}}
      {{- fail "remove KEDA_CLOUD_WORKLOAD_IDENTITY_AUDIENCES when selecting legacy token mode" -}}
    {{- end -}}
    {{- if $cloudEntries -}}
      {{- fail "configure cloud workload identity audiences through chart values or env, not both" -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}
