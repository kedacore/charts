# Copilot Instructions

## Code review

### Helm template: consistent fallback patterns

When a template value has a component-level override falling back to a global default
(e.g. `tolerations`, `affinity`, `nodeSelector`), prefer the `with`/`default` pattern
over `if`/`else if`:

```yaml
# Preferred — single toYaml, nindent only once
{{- with .Values.component.tolerations | default .Values.tolerations }}
tolerations:
  {{- toYaml . | nindent 8 }}
{{- end }}

# Avoid — duplicated toYaml, easy to forget nindent on one branch
{{- if .Values.component.tolerations }}
tolerations:
  {{- toYaml .Values.component.tolerations | nindent 8 }}
{{- else if .Values.tolerations }}
tolerations:
  {{- toYaml .Values.tolerations | nindent 8 }}
{{- end }}
```

The `if`/`else` variant requires repeating `toYaml | nindent` in every branch, and a
missing `nindent` produces invalid YAML that only surfaces at deploy time. The
`with`/`default` variant has a single output point, eliminating that class of bug.

### Helm template: nindent on every toYaml

Every `toYaml` that emits block content (lists or maps) must be piped through `nindent`
(or `indent`). Flag any `toYaml` that is missing indentation control — the resulting
YAML will almost certainly be invalid.
