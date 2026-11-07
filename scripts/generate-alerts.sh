#!/usr/bin/env bash
# scripts/generate-alerts.sh — Generate synthetic alert incidents for the DR
# dashboard. Runs in CI on a schedule; output committed to alerts/last-run.json.
#
# Output schema (incidents[]):
#   id, title, severity (critical/high/medium/low), status
#   (firing/resolved/acknowledged), service, source
#   (prometheus/cloudwatch/gcp-monitoring/grafana), runbook, createdAt
set -euo pipefail

mkdir -p alerts

python3 - <<'PYEOF'
import json, datetime, random

random.seed(42)  # deterministic demo data

services = [
    "payments-api", "user-service", "inventory-service", "notification-service",
    "auth-service", "order-service", "catalog-service", "search-service",
]
sources = ["prometheus", "cloudwatch", "gcp-monitoring", "grafana"]
severities = ["critical", "high", "medium", "low"]
statuses = ["firing", "resolved", "acknowledged"]
runbooks = [
    "runbooks/high-severity.md",
    "runbooks/incident-response.md",
]

now = datetime.datetime.now(datetime.timezone.utc)
incidents = []
n = random.randint(5, 8)
for i in range(n):
    created = now - datetime.timedelta(minutes=random.randint(0, 180))
    incidents.append({
        "id": f"inc-{1000 + i}",
        "title": f"High {random.choice(services).title()} latency detected",
        "severity": random.choice(severities),
        "status": random.choice(statuses),
        "service": random.choice(services),
        "source": random.choice(sources),
        "runbook": random.choice(runbooks),
        "createdAt": created.isoformat(),
    })

data = {"incidents": incidents, "generatedAt": now.isoformat()}

with open("alerts/last-run.json", "w") as f:
    json.dump(data, f, indent=2)

print(f"Generated {len(incidents)} incidents -> alerts/last-run.json")
PYEOF
