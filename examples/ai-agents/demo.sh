#!/usr/bin/env bash
#
# ai-agents demo — a scoped multi-agent workspace with an HMAC-signed channel,
# then screen a batch of inter-agent messages (some injected) against the gate.
#
# Screening only inspects — nothing is executed. ~45 seconds.
#
# Usage:  ./demo.sh [--yes]
# Needs:  a2a (npm install -g a2a-trustgate) + activated key.

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YES=0; for a in "$@"; do [ "$a" = "--yes" ] && YES=1; done
command -v a2a >/dev/null 2>&1 || { echo "a2a not found — install: npm install -g a2a-trustgate"; exit 1; }
confirm() { [ "$YES" -eq 1 ] && return 0; read -r -p "$1 [y/N] " a; case "$a" in y|Y) return 0;; *) return 1;; esac; }

echo "▶ 1/3  Create a scoped workspace + agents (see agents.json)"
if confirm "Create workspace 'research-swarm' with 3 scoped agents?"; then
  a2a workspace create "research-swarm"
  echo "   then, per agent:  a2a workspace <WS-ID> add-agent --name planner --role expert"
fi
echo

echo "▶ 2/3  Open an HMAC-signed channel"
echo "   a2a channel create ops-bus"
echo "   a2a channel <CH-ID> send \"interface frozen — you're clear to build\""
echo

echo "▶ 3/3  Screen inter-agent messages (injected ones should not cross the boundary):"
while IFS= read -r msg; do
  case "$msg" in ''|\#*) continue;; esac
  printf '   %-52s ' "${msg:0:52}"
  a2a eval "$msg" --json >/dev/null 2>&1; rc=$?
  case "$rc" in 0) echo "✓ allow";; 2) echo "⏸ review";; *) echo "✗ BLOCK";; esac
done < "$DIR/rogue-messages.txt"
echo
echo "Done. Inspect the audit trail:"
echo "  a2a audit"
