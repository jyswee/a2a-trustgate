# a2a-trustgate

[![npm version](https://img.shields.io/npm/v/a2a-trustgate.svg)](https://www.npmjs.com/package/a2a-trustgate)
[![EU AI Act](https://img.shields.io/badge/EU_AI_Act-aligned-14b8a6)](https://a2ainfrastructure.com/compliance)
[![OCSF audit](https://img.shields.io/badge/audit-OCSF_native-14b8a6)](#the-audit-trail-an-auditor-will-accept)
[![MCP](https://img.shields.io/badge/MCP-49_tools-blue)](https://a2ainfrastructure.com/quickstart/mcp)

# Compliance for AI systems in production.

**You put an AI agent in production. Now prove it's safe — to your auditor, your regulator, your board.**

A2A TrustGate screens every action an agent takes *before* it runs, and writes the decision to an immutable, SIEM-ready audit trail. Not a policy document that says agents *should* behave — a control that stops the ones that don't, and the evidence to prove it.

- **Enforced, not promised.** Every agent action passes a 4-gate firewall before it executes. Out-of-policy actions are blocked in milliseconds, not flagged after the fact.
- **An audit trail an auditor will accept.** Every decision — allowed or blocked, with reasoning — lands in an append-only, OCSF-native log that drops straight into Splunk, Sentinel, Chronicle or Elastic.
- **Mapped to the frameworks you're measured against.** Export the same evidence against EU AI Act, SOC 2, NIST AI RMF, HIPAA and academic-integrity controls — article by article, control by control.
- **Provable scope.** Each agent may act only within the permissions it was granted. Deny-by-default, and every boundary is in the log.

**Who it's for:** compliance and risk teams putting AI into regulated production — financial services, healthcare, network operations, creative/IP rights, enterprise AI adoption, and research institutions. If someone can ask you *"prove your AI is safe,"* this is the answer.

[![a2a demo — screen an agent action in one command](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/a2a-hero-1200.gif)](https://a2ainfrastructure.com/#demo)

*Agent proposes an action, the gate screens it, the decision lands in the audit trail — [watch the full demo](https://a2ainfrastructure.com/#demo).*

---

## The audit trail an auditor will accept

Most "AI governance" is a PDF that describes intentions. A2A produces evidence. Every screened action becomes a genuine **OCSF Detection Finding** — the same schema your SOC already ingests — with a tamper-evident content hash and the full decision reasoning:

```bash
a2a audit                          # recent decisions, allowed and blocked
a2a audit export --format ocsf     # OCSF Detection Findings — straight into your SIEM
a2a audit export --format csv      # hand a spreadsheet to an auditor
```

- **OCSF-native (schema 1.1.0).** Not a bespoke JSON blob labelled "OCSF" — real Detection Findings that Splunk / Sentinel / Chronicle / Elastic parse without a custom connector.
- **Tamper-evident.** Every record carries a content hash; the export is append-only. You can prove the log wasn't edited after the fact.
- **Framework-mapped exports.** The same underlying events export against the control set you're being audited on:

| Framework | What you can hand over |
|---|---|
| **EU AI Act** | Article-by-article evidence of screening, logging and human oversight (Art. 12, 14, 26, 53) |
| **SOC 2** | Control-mapped decision log (CC-series) |
| **NIST AI RMF** | GOVERN / MAP / MEASURE / MANAGE evidence |
| **HIPAA** | Security & Privacy Rule access decisions |
| **Academic integrity / QAA** | Research-ethics and responsible-AI trail |

> **EU AI Act deployer?** Read the [EU AI Act compliance reference](./docs/eu-ai-act.md) — an article-by-article crosswalk (Art. 12 record-keeping, Art. 14 human oversight, Art. 26 deployer obligations) with citations to the official EUR-Lex text. The Regulation becomes generally applicable **2 August 2026**.

## Enforced before it runs — the 4-gate firewall

Compliance you can prove starts with a control that actually stops things. Every action passes four gates before it's allowed to execute:

- **Gate 1 — deterministic rules.** Pattern and policy screening in milliseconds: destructive operations, secret exfiltration, injection signatures. No model call.
- **Gate 2 — self-evaluation.** For anything Gate 1 can't clear outright: *should this run, given the context and the tenant's policy?*
- **Gate 3 — behavioral analysis.** Abuse patterns across a run — bursts, probing, escalation — not just the single action in isolation.
- **Gate 4 — scope enforcement.** Per-agent permissions: each agent may act only within the scope it was granted. Out-of-scope actions are denied by default.

The firewall only ever *tightens* a decision — allow → review → block. A safe action stays fast; a risky one is stopped and recorded with the reason.

---

## For developers — screen an action in one command

The whole control is a CLI (and an MCP server). Wrapping a risky step is one line, and exit codes make it scriptable:

```bash
a2a eval "rm -rf ./build"          # ✓ ALLOWED   (exit 0)
a2a eval "rm -rf /"                # ✗ BLOCKED   (exit 1) — filesystem destruction pattern
a2a eval "command" --context ctx   # add decision context   (exit 2 = needs review)
```

| Code | Meaning |
|------|---------|
| 0 | Allowed — safe to execute |
| 1 | Blocked — do not execute |
| 2 | Needs review — Gate 2 self-evaluation required |

**Works with:** Claude Code · Cursor · Cline · Windsurf · Aider · Codex · any MCP client.

## Install

```bash
npm install -g a2a-trustgate
```

The npm package is `a2a-trustgate`; the command is `a2a`.

## Quick Start

```bash
# Create a tenant (agent-first — human activates the key)
a2a signup my-company --local

# Screen a command — exit 0 = allowed, 1 = blocked, 2 = needs review
a2a eval "rm -rf ./build"
# ✓ ALLOWED

a2a eval "rm -rf /"
# ✗ BLOCKED: filesystem destruction pattern

# See plan, usage, limits
a2a status

# Full reference
a2a --help
```

> Your key is issued immediately but returns **402** until you start your **7-day free trial** ($0 today) — `a2a signup` prints the activation link. Cancel before day 7 and you're never charged.

The eval call has a few knobs, and it's scriptable — wrap any risky step:

```bash
a2a eval "command" --gate2 self    # self-evaluate (default)
a2a eval "command" --gate2 skip    # Gate 1 only (fast path)
a2a eval "command" --pipeline ID   # route through a named pipeline

if a2a eval "rm -rf ./build" --json 2>/dev/null; then
  rm -rf ./build
fi
```

## Built for six kinds of team

A2A screens the same way for everyone and produces the same audit trail — but the surface each team touches, and the framework they're measured against, is different. Pick yours.

### Network operations — a gate in front of every device

Your agents run commands against routers, switches, and sites. A2A registers each device, enforces a per-device policy, and gives you a killswitch that stops every agent at once.

```bash
a2a device add --name core-rtr-1 --host 10.0.0.1 --vendor cisco
a2a device policy DEVICE-ID --mode strict --require-approval --max 5
a2a device lock DEVICE-ID           # freeze a single device
a2a killswitch                      # freeze every agent, everywhere
a2a device import --file hosts.csv  # bulk onboard (name,host,vendor,model,role,siteCode)
```

| Agent screens a command | Human sees the device-lock |
|---|---|
| [![network-ops terminal cast](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/network-ops-cast.gif)](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/network-ops.mp4) | [![network-ops dashboard](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/network-ops-plate.png)](https://a2ainfrastructure.com/use-cases/network-ops) |

*Watch the full clip: [network-ops →](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/network-ops.mp4)*

### AI agents — agent-to-agent, screened and signed

Multi-agent systems where one agent's output is another's input. A2A gives them scoped workspaces and HMAC-signed channels, so a rogue or injected message can't cross a boundary you didn't grant.

```bash
a2a workspace create "research-swarm"
a2a workspace WS-ID add-agent --name planner --role expert
a2a workspace WS-ID enforce --agent planner "command"   # screen an agent's action
a2a channel create ops-bus
a2a channel CH-ID send "interface frozen — you're clear to build"  # HMAC-signed
```

| Agent-to-agent evaluate | Human sees the block + audit |
|---|---|
| [![ai-agents terminal cast](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/ai-agents-cast.gif)](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/ai-agents.mp4) | [![ai-agents dashboard](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/ai-agents-plate.png)](https://a2ainfrastructure.com/use-cases/ai-agent-platforms) |

*Watch the full clip: [ai-agents →](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/ai-agents.mp4)*

### Regulated industries — an immutable, exportable audit trail

Every decision — allowed or blocked, with reasoning — lands in an append-only log you can export for an auditor. OCSF-native Detection Findings, EU AI Act aligned.

```bash
a2a audit                          # recent decisions
a2a audit export --format ocsf     # OCSF Detection Findings → your SIEM
a2a audit export --format csv      # hand to an auditor (csv/json)
a2a approvals                      # human-in-the-loop queue
a2a approve TASK-ID
a2a reject TASK-ID "out of policy" # reason recorded in the trail
```

| Command screened | Human exports the audit |
|---|---|
| [![regulated terminal cast](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/regulated-cast.gif)](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/regulated.mp4) | [![regulated dashboard](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/regulated-plate.png)](https://a2ainfrastructure.com/use-cases/regulated-industries) |

*Watch the full clip: [regulated →](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/regulated.mp4)*

### Creative & IP owners — licence before access

Register your catalogue, mint scoped licences, and every agent that reaches for an asset is checked against a rights log. Access is granted by licence, not by scraping.

```bash
a2a catalogue create "The Back Catalogue"
a2a catalogue licence create --catalogue CAT-ID --email studio@label.com --scope read
a2a catalogue access-log           # who reached for what, and whether it was licensed
a2a catalogue content-sources
```

| Agent requests an asset | Human sees the rights-log |
|---|---|
| [![creative terminal cast](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/creative-cast.gif)](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/creative.mp4) | [![creative dashboard](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/creative-plate.png)](https://a2ainfrastructure.com/use-cases/creative-industries) |

*Watch the full clip: [creative →](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/creative.mp4)*

### IP aggregators & distributors — onboard an entire catalogue in one command

Represent many rights holders? A distributor or aggregator holds **one** provider key and onboards every artist's repertoire in bulk — each work stamped with an `ownerRef` (the artist's stable id in *your* system) so reads and writes are hard-scoped per rights holder. The same integration works for one artist or a million.

Export your catalogue as CSV (CD Baby, DistroKid and most distributors already do), then:

```bash
# One-time: get a provider key from your A2A partner account, then
export A2A_API_KEY=a2a_provider_xxxxxxxx

# Preview the column mapping before writing anything
a2a ip-aggregator import repertoire.csv --dry-run

# Bulk-import the whole repertoire (idempotent — safe to re-run)
a2a ip-aggregator import repertoire.csv

a2a ip-aggregator owners                          # every rights holder + work count
a2a ip-aggregator works --owner-ref crosswinds    # one artist's registered works
a2a ip-aggregator opt-out --owner-ref crosswinds --all   # bulk AI/TDM opt-out (EU AI Act Art. 53)
a2a ip-aggregator portal-link --owner-ref crosswinds     # white-label artist portal — drop the artist in, no second login
a2a ip-aggregator access-log --owner-ref crosswinds      # the provable trail, per artist

# The licensee side (the AI company that wants to use the catalogue):
a2a ip-aggregator catalogue                              # the licensable catalogue (opted-out works excluded)
a2a ip-aggregator licensee-link --licensee-ref acme-ai   # white-label licensee portal — browse + request a scoped licence
```

A CD Baby-style CSV maps automatically — headers like `Artist ID`, `Artist`, `Track Title`, `ISRC`, `TDM Opt-Out` are recognised (override any column with `--owner-ref-col` / `--isrc-col` / `--title-col`):

```csv
Artist ID,Artist,Track Title,ISRC,TDM Opt-Out
crosswinds,Crosswinds,All Good Things,USCGH1915861,true
midnight_owls,Midnight Owls,Neon Rain,GBK4Y2100017,false
```

`portal-link` mints a short-lived signed handoff URL, so you can embed a **white-label rights portal** straight into your own product — your brand, no A2A login, per-artist isolated. This is the drop-in pattern behind [BandSaaS](https://bandsaas.com); the same one an aggregator embeds for its whole roster. `licensee-link` mints the mirror portal for an AI company (a `licenseeRef`) to browse the licensable `catalogue` and request scoped licences — the artist approves in their own portal, which issues a revocable licence. Both sides stay inside your product.

### Work orders — govern the *authority*, not just the action

The gates prove every action was screened. A **work order** proves the layer above: *who authorised this work, under what authority, toward what outcome* — and binds it to a signed, tamper-evident completion record. This is the enterprise governance layer, sitting directly on top of the 4-gate firewall.

```bash
# A named human raises a governed directive with RACI + a scope grant
a2a work-order create --ref WO-2026-0142 --title "Summarise Q3 catalogue" \
  --directive "Summarise tracks in the Q3 batch for the licensing review" \
  --accountable jane@label.com --authority "licensing-review-ticket-88" \
  --domain creative --scope "read,summarise.*"

# --domain applies your sector's profile: network-ops (change request), regulated
# (work order / Art 4 decision record — authority required), creative (usage
# authorisation), enterprise-ai (approved use), university (research protocol —
# ethics ref required), ai-agents (mission). Add sector context with --meta
# key=value, e.g. --meta grantRef=EPSRC-42 or --meta aiTools=copilot,chatgpt

a2a work-order authorise WO-...     # human sign-off: DRAFT → AUTHORISED (Art. 14)
a2a work-order attach WO-... TASK   # attach the gated tasks that fulfil it
a2a work-order complete WO-... --outcome "42 tracks summarised, 0 blocked"
a2a work-order verify WO-...        # re-derive the hashes — proves nothing was altered
a2a work-order precedent "summarise catalogue for licensing"   # what was authorised before
```

Once authorised, the work order's scope grant becomes the **ceiling** of what the job may do — an action outside it is blocked at evaluation time, even if the agent's own role would allow it. The completion record is signed with a key only A2A can reproduce, so an auditor (or the accountable human) can re-verify the whole chain — directive → actions → gate verdicts → outcome — and detect any later tampering.

### Enterprise AI — govern the tools your staff already use

ChatGPT, Claude, Copilot are already in your building. Register each tool, screen what it's asked to do, and get one audit trail across all of them.

```bash
a2a ai-tools add "ChatGPT" --type chatbot
a2a ai-tools                       # every registered tool
a2a ai-tools update 0 --status paused
```

| Tool action screened | Human sees approval + audit |
|---|---|
| [![enterprise-ai terminal cast](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/enterprise-ai-cast.gif)](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/enterprise-ai.mp4) | [![enterprise-ai dashboard](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/enterprise-ai-plate.png)](https://a2ainfrastructure.com/use-cases/enterprise-ai) |

*Watch the full clip: [enterprise-ai →](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/enterprise-ai.mp4)*

### Universities — research governance without the friction

Approvals, scope enforcement, and an exportable trail that maps to research-ethics and UKRI responsible-AI requirements. One URL for a researcher to connect, governance for the board.

```bash
a2a eval "command" --context "grant-XYZ research pipeline"
a2a approvals                      # ethics/governance queue
a2a audit export --format csv      # for the board or the funder
```

| Research action screened | Human sees governance + audit |
|---|---|
| [![university terminal cast](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/university-cast.gif)](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/university.mp4) | [![university dashboard](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/university-plate.png)](https://a2ainfrastructure.com/use-cases/university) |

*Watch the full clip: [university →](https://prodmedia.tyga.host/public/tyga.cloud/landing/a2ainfrastructure.com/icp/university.mp4)*

## Drop it into your framework

Generate a ready-made wrapper for the SDK you already use — the screen call is one line:

```bash
a2a generate node        # a2a-safety.js
a2a generate python      # a2a_safety.py
a2a generate anthropic   # tool_use wrapper
a2a generate openai      # tool_call wrapper
```

## MCP Server

Prefer tools over a CLI? `a2a` ships an MCP server. Point Claude Code (or any MCP client) at it and your agent gets **49 native tools**: evaluate, pipelines, workspaces, channels, devices, sites, catalogues, audit, approvals, admin. The whole platform.

```bash
claude mcp add a2a -- a2a mcp-serve
```

For clients that use a JSON config (Cline, Cursor, Windsurf), pass your API key via the `A2A_API_KEY` environment variable. The MCP server runs outside your project directory, so it will not pick up `.a2a/config.json`:

```json
{
  "mcpServers": {
    "a2a": {
      "command": "a2a",
      "args": ["mcp-serve"],
      "env": { "A2A_API_KEY": "a2a_your_key_here" }
    }
  }
}
```

No key yet? Start it without one: the server boots in onboarding mode and can guide signup, then add the key and restart.

### Remote MCP — zero install

No CLI at all? Claude Web, Claude Desktop, Raycast, or any hosted MCP client can connect straight to our remote server. Same 49 tools, same API key, nothing to install:

```
URL:  https://mcp.a2ainfrastructure.com/sse
Auth: Authorization: Bearer YOUR_API_KEY
```

Setup guide: [MCP quickstart](https://a2ainfrastructure.com/quickstart/mcp).

## Features

- **Evaluate** — screen any command through the 4-gate firewall, allow / block / needs-review, in milliseconds
- **Pipelines** — named screening routes with their own policy and task history
- **Workspaces** — scoped multi-agent enforcement, one agent's action screened against the tenant policy
- **Channels** — HMAC-signed agent-to-agent messaging, contract-scoped
- **Devices & sites** — per-device policy, lock, bulk CSV import, and a global killswitch (network-ops)
- **Catalogues & licences** — register IP, mint scoped licences, access-log every reach (creative / IP owners)
- **IP aggregator** — one provider key, bulk-import many rights holders' repertoires (CSV), per-artist `ownerRef` isolation + white-label portal links (distributors / aggregators)
- **AI tools registry** — govern ChatGPT / Claude / Copilot behind one audit trail (enterprise-ai)
- **Approvals** — human-in-the-loop queue, approve/reject with reason recorded
- **Audit trail** — immutable, OCSF-native Detection Findings, EU AI Act aligned, exportable as OCSF / CSV / JSON
- **MCP server** — 49 tools, local (`a2a mcp-serve`) or fully remote (`mcp.a2ainfrastructure.com`)
- **Framework wrappers** — one-line generate for Node, Python, Anthropic, OpenAI

**Pricing:** every plan starts with a **7-day free trial** — card required, **$0 today**, cancel any time before day 7 and you're never charged. The full 4-gate firewall, behavioral analysis and OCSF-shaped audit are on **every** plan; higher tiers add volume, webhooks, custom rules, dedicated sandboxes and SSO.

| Plan | Price | Screenings / mo | Overage per 1k |
|------|-------|-----------------|----------------|
| **Starter** | $99/mo | 5,000 | $1.00 |
| **Pro** | $299/mo | 100,000 | $0.25 |
| **Enterprise** | Custom — priced per account | Unlimited | Agreed per account |

Verified education & research: **Institutional** $79/mo. [Full pricing →](https://a2ainfrastructure.com/pricing).

## Authentication

API key resolution (first match wins):

1. `--key` flag
2. `A2A_API_KEY` environment variable
3. `./.a2a/config.json` (project-local)
4. `~/.a2a/config.json` (global)

```bash
a2a login            # store globally (~/.a2a/)
a2a login --local    # store per-project (./.a2a/) — add .a2a/ to .gitignore
a2a config           # show which config is active
```

## Platform operators — `a2a admin`

Self-hosted or platform-operator deployments get a full ops suite behind a separate
superadmin key (`A2A_SA_KEY` / `--sa-key` — never a tenant API key): tenant lifecycle
(`tenant-create --theme --password --verify`, `tenant-key` mint), partner management
(`partner-embed` with incremental `--frame-add`/`--frame-remove`, brand config, secret
rotation), cross-tenant IP ops (`catalogues`, `catalogue-restamp`, `catalogue-restore`,
`licences`, `licence-revoke`, `access-log`), deck shares, partner provisions/usage, and
billing ops (`subscriptions`, `invoices`). Run `a2a admin help` for the full list.

## Agent Integration

Add to your CLAUDE.md, .cursorrules, .clinerules, .windsurfrules, or AGENTS.md:

```
## A2A TrustGate
This project screens agent actions through A2A before they execute.
Use the `a2a` CLI. Config is in .a2a/config.json (auto-loaded).
If not configured: a2a login --local --key YOUR_KEY

Before running any risky command, screen it:
  a2a eval "the command" --json   # exit 0 = run it, 1 = do not, 2 = needs review
```

## Why this exists

An agent that can act is an agent that can act *wrongly* — and by the time you read the log, it's done. I wanted a gate in front of the action, not a report after it: deterministic where it can be, self-evaluating where it can't, and audited either way. It's early and I'm iterating fast — if something's rough or missing, [tell us](https://a2ainfrastructure.com/feedback).

## Documentation

- [Quickstart Guides](https://a2ainfrastructure.com/quickstart)
- [Full Reference](https://a2ainfrastructure.com/llms.txt)

## Licence

Proprietary — Tyga.Cloud Ltd. See [LICENSE](./LICENSE).
