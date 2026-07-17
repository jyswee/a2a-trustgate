#!/usr/bin/env bash
#
# university demo — model research grants as agent scopes, then screen research-agent
# actions against a grant's scope + ethics approval. In-scope work is allowed; anything
# the ethics approval doesn't cover (re-identification, un-consented contact, out-of-scope
# linkage) is blocked. Every decision lands on a review-ready audit trail. ~45 seconds.
#
# Screening (`a2a eval`) only inspects — nothing is executed. Safe to run.
#
# Usage:  ./demo.sh [--yes]
# Needs:  a2a (npm install -g a2a-trustgate) + activated key (a2a signup / login).

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YES=0; for a in "$@"; do [ "$a" = "--yes" ] && YES=1; done
command -v a2a >/dev/null 2>&1 || { echo "a2a not found — install: npm install -g a2a-trustgate"; exit 1; }

echo "▶ 1/3  Grants as agent scopes (see grants.json — scope + ethics approval per grant)"
echo "   a2a eval \"<action>\" --scope UKRI-EP-2026-0417"
echo

screen_file() {  # $1 = file, $2… = extra a2a eval flags
  local file="$1"; shift
  while IFS= read -r act; do
    case "$act" in ''|\#*) continue;; esac
    printf '   %-52s ' "${act:0:52}"
    a2a eval "$act" "$@" --json >/dev/null 2>&1; rc=$?
    case "$rc" in 0) echo "✓ allow";; 2) echo "⏸ review";; *) echo "✗ BLOCK";; esac
  done < "$file"
}

echo "▶ 2/3  Screen agent actions across the university's silos (nothing is executed):"
echo "   · research — against the grant scope + ethics approval:"
screen_file "$DIR/actions.txt" --scope grant
echo "   · student records — FERPA / UK-GDPR disclosure:"
screen_file "$DIR/student-records.txt"
echo "   · academic integrity — QAA, AI-in-coursework:"
screen_file "$DIR/coursework.txt"
echo

echo "▶ 3/3  Produce a review-ready ethics export (append-only):"
echo "   a2a audit export --format csv  > ethics-audit.csv"
echo "   a2a audit export --format json > ethics-audit.json"
echo "   (see ethics-crosswalk.md for the UKRI / REC / QAA / UK-GDPR mapping)"
echo
echo "Done. Inspect the trail:"
echo "  a2a audit"
