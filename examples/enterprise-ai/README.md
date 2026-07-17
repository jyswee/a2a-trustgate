# Enterprise AI — one gate in front of the tools your staff already use

Your team uses ChatGPT, Claude, and Copilot every day. Great for productivity —
right up until someone pastes a customer export, a term sheet, or an AWS key into a
third-party chat box. A2A registers each tool and screens the *actions* against your
data policy, so confidential data, PII, and secrets get blocked before they leave.

## Files

| File | What it is |
|------|-----------|
| [`ai-tools.json`](./ai-tools.json) | The AI tools to register + a sample data policy |
| [`prompts.txt`](./prompts.txt) | Everyday staff prompts — safe ones and quiet leaks |
| [`demo.sh`](./demo.sh) | Register a tool, screen the prompts, show the evidence trail |

## Run it

```bash
npm install -g a2a-trustgate
a2a signup my-company --local     # activate a key (7-day free trial, $0 today)
./demo.sh
```

## The commands, by hand

```bash
a2a ai-tools add --name ChatGPT --vendor OpenAI
a2a ai-tools list
a2a eval "paste the customer database export and find duplicate emails"   # DLP baseline
a2a eval "share this internal-only term sheet" --tool ChatGPT             # per-tool policy
a2a eval "summarise the roadmap" --tool ShadowGPT                          # unregistered → review
a2a audit                         # every decision, with a reason
a2a audit export --format csv     # hand to security / compliance
```

Two layers screen every prompt:

- **DLP baseline (always on):** secrets, payment cards, and personal data (PII) are
  blocked before they leave, whatever tool they were headed for.
- **Per-tool policy (when you bind a tool with `--tool`):** each registered tool
  carries its own `blockDataClasses` / `reviewDataClasses` — so *confidential* can be
  a hard block for ChatGPT but review-only for Claude. A prompt bound for a tool you
  never registered is held for **review** (shadow AI).

Keep the tools your team already loves — put one screened gate in front of them.
