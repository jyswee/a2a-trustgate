#!/usr/bin/env bash
#
# examples dispatcher — run any ICP kit's demo.
#
#   ./demo.sh <kit> [--yes]
#   ./demo.sh --list
#
# Kits: network-ops | ai-agents | regulated | creative | enterprise-ai | university
#
# Every demo makes real `a2a eval` calls that only inspect commands — nothing is
# executed. Needs a2a (npm install -g a2a-trustgate) + an activated key.

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KITS=(network-ops ai-agents regulated creative enterprise-ai university)

list() { printf 'Available kits:\n'; for k in "${KITS[@]}"; do printf '  %s\n' "$k"; done; }

case "${1:-}" in
  ''|-h|--help) echo "Usage: ./demo.sh <kit> [--yes]"; echo; list; exit 0;;
  --list) list; exit 0;;
esac

kit="$1"; shift
for k in "${KITS[@]}"; do
  if [ "$k" = "$kit" ]; then
    exec bash "$DIR/$kit/demo.sh" "$@"
  fi
done

echo "Unknown kit: $kit" >&2
echo >&2
list >&2
exit 1
