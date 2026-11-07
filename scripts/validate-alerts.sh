#!/usr/bin/env bash
# scripts/validate-alerts.sh — Validate alerts/last-run.json schema.
#
# Checks that each incident has required fields and valid severity/status values.
set -euo pipefail

python3 - <<'PYEOF'
import json, sys

with open("alerts/last-run.json") as f:
    data = json.load(f)

incidents = data.get("incidents", [])
if not isinstance(incidents, list):
    print("ERROR: incidents is not a list")
    sys.exit(1)

required = ["id", "title", "severity", "status", "service", "source", "runbook", "createdAt"]
valid_severity = {"critical", "high", "medium", "low"}
valid_status = {"firing", "resolved", "acknowledged"}

errors = []
for i, inc in enumerate(incidents):
    for field in required:
        if field not in inc:
            errors.append(f"incident[{i}] missing field: {field}")
    if inc.get("severity") not in valid_severity:
        errors.append(f"incident[{i}] invalid severity: {inc.get('severity')}")
    if inc.get("status") not in valid_status:
        errors.append(f"incident[{i}] invalid status: {inc.get('status')}")

if errors:
    for e in errors:
        print(e)
    sys.exit(1)

print(f"Validated {len(incidents)} incidents — schema OK")
PYEOF
