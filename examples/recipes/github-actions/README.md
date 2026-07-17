# Recipe — screen agent commands in CI

Two GitHub Actions workflows:

- [`agent-guardrail.yml`](./agent-guardrail.yml) — runs every command in `commands.txt`
  through the gate and **fails the job if anything is blocked**. Wire it to pull
  requests so an agent-authored change can't merge a destructive or injected command.
- [`injection-regression.yml`](./injection-regression.yml) — replays the labelled
  prompt-injection corpus and **fails the build if agreement drops below a threshold**
  (`./run.sh prompt-injections.jsonl --min 90`), catching guardrail drift over time.

## Install

1. Copy [`agent-guardrail.yml`](./agent-guardrail.yml) to `.github/workflows/`.
2. Add a repo secret `A2A_API_KEY` (Settings → Secrets → Actions) — an `a2a_…` key.
3. Put the commands to screen in a `commands.txt` at the repo root (one per line).

## What it does

| Verdict | Exit code | CI outcome |
|---------|-----------|------------|
| allow   | 0 | `::notice::` — passes |
| review  | 2 | `::warning::` — passes, flagged |
| block   | 1 | `::error::` — **fails the job** |

Screening only inspects — nothing is executed in CI.
