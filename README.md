# Synthetic Alerts for Incident Dashboards

Standalone portfolio project: deterministic synthetic incident generator and
validator for testing incident dashboards — no real observability credentials
needed.

## What it demonstrates

- **Synthetic alert aggregation**: CI generates sanitized demo incidents with
  severity, status, service, source, and runbook links.
- **Alert validation**: schema checks that each incident has required fields and
  valid severity/status values.

## Output schema (`alerts/last-run.json`)

```json
{
  "incidents": [
    {
      "id": "inc-1000",
      "title": "High <service> latency detected",
      "severity": "critical|high|medium|low",
      "status": "firing|resolved|acknowledged",
      "service": "<service>",
      "source": "prometheus|cloudwatch|gcp-monitoring|grafana",
      "runbook": "runbooks/<runbook>.md",
      "createdAt": "<ISO-8601>"
    }
  ],
  "generatedAt": "<ISO-8601>"
}
```

## Usage

```bash
bash scripts/generate-alerts.sh    # generate deterministic demo incidents -> alerts/last-run.json
bash scripts/validate-alerts.sh    # validate alerts/last-run.json schema
```

## Repository layout

```
scripts/
  generate-alerts.sh    # CI: generate synthetic alert incidents
  validate-alerts.sh    # CI: validate alert schema
alerts/
  last-run.json          # Synthetic incidents (generated/committed by CI)
```

## License

MIT
