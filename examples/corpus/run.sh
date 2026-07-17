#!/usr/bin/env bash
#
# run.sh — replay the A2A TrustGate corpus through the live 4-gate firewall and
# score it. For each labelled sample it calls `a2a eval` and compares the gate's
# verdict (exit 0 = allow, 1 = block, 2 = review) to the expected label.
#
# This is a benchmark harness, not the firewall. The gate logic lives server-side;
# this only sends inputs and tallies verdicts — the same way promptfoo or garak
# score a model. Bring your own dataset by pointing it at any *.jsonl in this shape.
#
# Usage:
#   ./run.sh                       # score commands.jsonl
#   ./run.sh prompt-injections.jsonl
#   ./run.sh commands.jsonl --context "ci pipeline"
#   ./run.sh prompt-injections.jsonl --min 90    # CI gate: exit 1 if agreement < 90%
#
# Needs:  a2a (npm install -g a2a-trustgate) + an activated key (a2a signup / login).

set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="${1:-commands.jsonl}"
[ -f "$FILE" ] || FILE="$DIR/$FILE"
[ -f "$FILE" ] || { echo "Dataset not found: ${1:-commands.jsonl}"; exit 1; }
shift || true

# Split out an optional --min <pct> CI threshold; everything else passes to `a2a eval`.
MIN=0; EXTRA=()
while [ "$#" -gt 0 ]; do
  case "$1" in
    --min) MIN="${2:-0}"; shift 2;;
    *) EXTRA+=("$1"); shift;;
  esac
done

command -v a2a >/dev/null 2>&1 || { echo "a2a not found — install: npm install -g a2a-trustgate"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "node is required to parse the dataset"; exit 1; }

# Map a2a eval exit code → label.  0 allow · 1 block · 2 review
verdict_of() { case "$1" in 0) echo allow;; 1) echo block;; 2) echo review;; *) echo error;; esac; }

total=0; correct=0
declare -a MISSES=()

# Emit "input<TAB>expected" rows; works for both the "command" and "text" schema.
while IFS=$'\t' read -r input expected; do
  [ -z "$input" ] && continue
  total=$((total+1))
  a2a eval "$input" "${EXTRA[@]}" --json >/dev/null 2>&1
  got="$(verdict_of $?)"
  if [ "$got" = "$expected" ]; then
    correct=$((correct+1))
    printf '  \033[32m✓\033[0m %-8s %s\n' "$got" "${input:0:64}"
  else
    printf '  \033[31m✗\033[0m exp=%-7s got=%-7s %s\n' "$expected" "$got" "${input:0:64}"
    MISSES+=("exp=$expected got=$got :: ${input:0:80}")
  fi
done < <(node -e '
  const fs=require("fs"), f=process.argv[1];
  for (const line of fs.readFileSync(f,"utf8").split("\n")) {
    const s=line.trim(); if(!s) continue;
    let o; try{o=JSON.parse(s)}catch{continue}
    const input=o.command ?? o.text ?? "";
    const expected=o.expected ?? "";
    if(input) process.stdout.write(input.replace(/\t/g," ")+"\t"+expected+"\n");
  }
' "$FILE")

echo
pct=0; [ "$total" -gt 0 ] && pct=$(( correct * 100 / total ))
echo "Score: $correct/$total agree with the labels (${pct}%)  —  dataset: $(basename "$FILE")"
if [ "${#MISSES[@]}" -gt 0 ]; then
  echo "Disagreements (label vs gate — worth reviewing, not necessarily wrong):"
  printf '  - %s\n' "${MISSES[@]}"
fi

# CI regression gate: fail the build if agreement drops below --min.
if [ "$MIN" -gt 0 ]; then
  if [ "$pct" -lt "$MIN" ]; then
    echo "GATE FAIL: ${pct}% < required ${MIN}% — the guardrail regressed." >&2
    exit 1
  fi
  echo "GATE PASS: ${pct}% ≥ required ${MIN}%."
fi
