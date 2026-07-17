# A2A TrustGate — examples

Runnable, copy-paste examples for screening AI-agent actions with the `a2a` CLI.
Everything here is **inputs, sample data, and thin wrappers** — the screening logic
lives in the firewall, not in these files. Every `demo.sh` makes real `a2a eval`
calls that only *inspect* commands; nothing is executed.

## Start here — the agent-safety corpus

**[`corpus/`](./corpus/)** is an open, labelled benchmark of dangerous-vs-benign
agent actions and prompt-injection strings, each with an expected verdict. Run it
against the live gate — or against **your own** guardrail — and score the agreement.

```bash
npm install -g a2a-trustgate
a2a signup my-lab --local        # activate a key (7-day free trial, $0 today)
cd examples/corpus && ./run.sh
```

## By use case

| Folder | For | What it shows |
|--------|-----|---------------|
| [`network-ops/`](./network-ops/) | NOC / infra teams | Onboard a device fleet, screen commands, global killswitch |
| [`ai-agents/`](./ai-agents/) | Multi-agent builders | Scoped workspaces + HMAC-signed channels, screen rogue messages |
| [`regulated/`](./regulated/) | Finance / health / public sector | Append-only audit trail + EU AI Act crosswalk |
| [`creative/`](./creative/) | Rights & IP owners | A licence gate over a catalogue, access logging |
| [`enterprise-ai/`](./enterprise-ai/) | Companies using ChatGPT/Claude/Copilot | One gate in front of the AI tools staff already use |
| [`university/`](./university/) | Research & academia | Grants as scopes, ethics on the audit trail |

## Reusable recipes

| Folder | What it is |
|--------|-----------|
| [`recipes/github-actions/`](./recipes/github-actions/) | CI workflow that fails a PR if the gate blocks a command |
| [`recipes/pre-commit/`](./recipes/pre-commit/) | Git hook that screens staged commands before they commit |
| [`recipes/webhook-receiver/`](./recipes/webhook-receiver/) | ~40-line HMAC-verifying webhook receiver |

## Run any kit

```bash
./demo.sh network-ops      # or: ai-agents | regulated | creative | enterprise-ai | university
./demo.sh --list           # show all kits
```

Each kit also has its own `demo.sh` you can run from inside its folder.

## What these examples are (and aren't)

- **Are:** sample inputs, labelled datasets, config templates, and thin shell/CI
  wrappers around the public `a2a` CLI.
- **Aren't:** the firewall's rules, prompts, or internals. You can point the corpus
  at any screener — the labels are ground truth, not our implementation.

## The verdicts

`a2a eval` returns an exit code: **`0` allow** · **`1` block** · **`2` review**.
Verdicts can legitimately shift with the context you pass (`--context`, `--scope`,
tenant policy). Licence: see the repo [LICENSE](../LICENSE).
