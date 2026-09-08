#!/usr/bin/env bash
set -euo pipefail

WEBHOOK_URL="${HEALTHCHECK_WEBHOOK_URL:?Set HEALTHCHECK_WEBHOOK_URL}"
DISK_THRESHOLD=90
MEM_THRESHOLD=90

disk_used=$(df --output=pcent / | tail -1 | tr -dc '0-9')
mem_used=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')

alerts=()
[ "$disk_used" -ge "$DISK_THRESHOLD" ] && alerts+=("Disk usage at ${disk_used}% (threshold ${DISK_THRESHOLD}%)")
[ "$mem_used" -ge "$MEM_THRESHOLD" ] && alerts+=("Memory usage at ${mem_used}% (threshold ${MEM_THRESHOLD}%)")

if [ "${#alerts[@]}" -gt 0 ]; then
  message=$(printf '%s\\n' "${alerts[@]}")
  curl -sf -X POST "$WEBHOOK_URL" \
    -H 'Content-Type: application/json' \
    -d "{\"text\": \"⚠️ $(hostname): ${message}\"}"
fi
