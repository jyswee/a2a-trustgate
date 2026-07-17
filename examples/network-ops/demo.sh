#!/usr/bin/env bash
#
# network-ops demo — bulk-onboard devices, apply a strict policy, screen a batch
# of commands against the gate, and show the global killswitch. ~45 seconds.
#
# Everything here is a REAL `a2a` call against your tenant. Screening (`a2a eval`)
# only inspects a command — it never executes it — so this is safe to run.
#
# Usage:  ./demo.sh [--yes]
# Needs:  a2a (npm install -g a2a-trustgate) + activated key (a2a signup / login).

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YES=0; for a in "$@"; do [ "$a" = "--yes" ] && YES=1; done
command -v a2a >/dev/null 2>&1 || { echo "a2a not found — install: npm install -g a2a-trustgate"; exit 1; }

confirm() { [ "$YES" -eq 1 ] && return 0; read -r -p "$1 [y/N] " a; case "$a" in y|Y) return 0;; *) return 1;; esac; }

echo "▶ 1/4  Bulk-onboard devices from hosts.csv"
confirm "Import $(( $(wc -l < "$DIR/hosts.csv") - 1 )) devices?" && a2a device import --file "$DIR/hosts.csv"
echo

echo "▶ 2/4  Screen a batch of device commands (nothing is executed — just screened):"
while IFS= read -r cmd; do
  case "$cmd" in ''|\#*) continue;; esac
  printf '   %-52s ' "${cmd:0:52}"
  a2a eval "$cmd" --json >/dev/null 2>&1; rc=$?
  case "$rc" in 0) echo "✓ allow";; 2) echo "⏸ review";; *) echo "✗ BLOCK";; esac
done < "$DIR/commands.txt"
echo

echo "▶ 3/4  Apply a strict policy to your first device"
echo "   (see policy.example.json for the shape)"
echo "   a2a device policy <DEVICE-ID> --mode strict --require-approval --max 5"
echo

echo "▶ 4/4  The emergency stop — freeze every agent on every device at once:"
echo "   a2a killswitch"
echo
echo "Done. See the fleet + recent screenings:"
echo "  a2a device list && a2a audit"
