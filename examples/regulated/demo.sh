#!/usr/bin/env bash
#
# regulated demo — screen a batch of regulated-environment actions, then produce
# the auditor-ready export. Every decision (allow/block/review, with reasoning)
# lands on the append-only audit trail. ~45 seconds.
#
# Screening (`a2a eval`) only inspects — nothing is executed. Safe to run.
#
# Usage:  ./demo.sh [--yes]
# Needs:  a2a (npm install -g a2a-trustgate) + activated key (a2a signup / login).

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YES=0; for a in "$@"; do [ "$a" = "--yes" ] && YES=1; done
command -v a2a >/dev/null 2>&1 || { echo "a2a not found — install: npm install -g a2a-trustgate"; exit 1; }

echo "▶ 1/3  Screen a batch of regulated actions (nothing is executed — just screened):"
while IFS= read -r cmd; do
  case "$cmd" in ''|\#*) continue;; esac
  printf '   %-52s ' "${cmd:0:52}"
  a2a eval "$cmd" --json >/dev/null 2>&1; rc=$?
  case "$rc" in 0) echo "✓ allow";; 2) echo "⏸ review";; *) echo "✗ BLOCK";; esac
done < "$DIR/commands.txt"
echo

echo "▶ 2/3  Human oversight — sensitive actions wait for a person (EU AI Act Art. 14):"
echo "   a2a approvals            # list what's pending"
echo "   a2a approve <ID> --reason \"verified with treasury\""
echo

echo "▶ 3/3  Produce an auditor-ready export (append-only, OCSF-shaped):"
echo "   a2a audit export --format csv  > audit.csv"
echo "   a2a audit export --format json > audit.json   # drops into your SIEM"
echo "   (see sample-audit.ocsf.json for the row shape; eu-ai-act-crosswalk.md for the mapping)"
echo
echo "Done. Inspect the trail:"
echo "  a2a audit"
