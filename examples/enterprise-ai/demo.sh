#!/usr/bin/env bash
#
# enterprise-ai demo — register the AI tools your staff already use, then screen a
# batch of everyday prompts against your data policy. The ones that quietly leak
# confidential data, PII, or secrets to a third party get blocked. ~45 seconds.
#
# Screening (`a2a eval`) only inspects — nothing is executed or sent. Safe to run.
#
# Usage:  ./demo.sh [--yes]
# Needs:  a2a (npm install -g a2a-trustgate) + activated key (a2a signup / login).

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
YES=0; for a in "$@"; do [ "$a" = "--yes" ] && YES=1; done
command -v a2a >/dev/null 2>&1 || { echo "a2a not found — install: npm install -g a2a-trustgate"; exit 1; }
confirm() { [ "$YES" -eq 1 ] && return 0; read -r -p "$1 [y/N] " a; case "$a" in y|Y) return 0;; *) return 1;; esac; }

echo "▶ 1/3  Register the AI tools your staff use (see ai-tools.json)"
if confirm "Add 'ChatGPT' as a screened tool?"; then
  a2a ai-tools add --name ChatGPT --vendor OpenAI
  echo "   list them:  a2a ai-tools list"
fi
echo

echo "▶ 2/3  Screen everyday prompts against your data policy (nothing is sent):"
while IFS= read -r p; do
  case "$p" in ''|\#*) continue;; esac
  printf '   %-52s ' "${p:0:52}"
  a2a eval "$p" --json >/dev/null 2>&1; rc=$?
  case "$rc" in 0) echo "✓ allow";; 2) echo "⏸ review";; *) echo "✗ BLOCK";; esac
done < "$DIR/prompts.txt"
echo

echo "▶ 3/3  What got blocked, and why — your data-loss evidence:"
echo "   a2a audit                       # every screening decision, with a reason"
echo "   a2a audit export --format csv   # hand it to security / compliance"
echo
echo "Done. Point your team at one gate, keep the tools they already love."
