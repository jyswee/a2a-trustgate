#!/usr/bin/env bash
#
# creative demo — register a rights catalogue, attach a licence scope, then screen
# a batch of agent requests against it. Rights grabs (AI-training on opt-out works,
# out-of-territory sync, stripped attribution) get blocked; every access is logged.
# ~45 seconds.
#
# Screening (`a2a eval`) only inspects — nothing is executed. Safe to run.
#
# Usage:  ./demo.sh [--yes]
# Needs:  a2a (npm install -g a2a-trustgate) + activated key (a2a signup / login).

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YES=0; for a in "$@"; do [ "$a" = "--yes" ] && YES=1; done
command -v a2a >/dev/null 2>&1 || { echo "a2a not found — install: npm install -g a2a-trustgate"; exit 1; }
confirm() { [ "$YES" -eq 1 ] && return 0; read -r -p "$1 [y/N] " a; case "$a" in y|Y) return 0;; *) return 1;; esac; }

echo "▶ 1/3  Register a rights catalogue (see catalogue.json for the works + policy)"
if confirm "Create catalogue 'aurora-music-library'?"; then
  a2a catalogue create "aurora-music-library"
  echo "   then attach a licence scope:  a2a catalogue <CAT-ID> licence --scope sync-non-exclusive --territories GB,EU"
fi
echo

echo "▶ 2/3  Screen agent requests against the catalogue (nothing is executed):"
while IFS= read -r req; do
  case "$req" in ''|\#*) continue;; esac
  printf '   %-52s ' "${req:0:52}"
  a2a eval "$req" --scope catalogue --json >/dev/null 2>&1; rc=$?
  case "$rc" in 0) echo "✓ allow";; 2) echo "⏸ review";; *) echo "✗ BLOCK";; esac
done < "$DIR/requests.txt"
echo

echo "▶ 3/3  Who touched what — the access log is your licensing evidence:"
echo "   a2a catalogue <CAT-ID> access-log"
echo "   a2a catalogue <CAT-ID> content-sources    # what the agents pulled from"
echo
echo "Done. Inspect the trail:"
echo "  a2a audit"
