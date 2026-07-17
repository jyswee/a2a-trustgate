# AI agents — agent-to-agent, screened and signed

Multi-agent systems where one agent's output is another's input. A2A gives them
scoped workspaces and HMAC-signed channels, so a rogue or injected message can't
cross a boundary you didn't grant. Two controls back this:

- **Per-agent scope** — each agent has a role + scope; an action outside it is
  denied by default (an `expert` scoped `read,comment` can't `deploy`; an `observer`
  never executes; an `architect` delegates). Pass `--agent <name>` to screen against it.
- **Injection pre-filter** — a high-precision structural check over inter-agent
  messages (instruction-override, persona-jailbreak, smuggled system directives,
  encoding evasion, zero-width obfuscation, exfiltration) that runs *before* the LLM
  gate — so it holds even on the free tier. Subtle-semantic manipulation is left to
  the gate on Pro+.

## Files

| File | What it is |
|------|-----------|
| [`agents.json`](./agents.json) | A 3-agent workspace with per-agent scopes + a channel |
| [`rogue-messages.txt`](./rogue-messages.txt) | Inter-agent messages — legit, injected, and out-of-scope |
| [`demo.sh`](./demo.sh) | Build the workspace, open a channel, screen the messages |

The labelled prompt-injection corpus lives in [`../corpus/`](../corpus/); wire it as a
CI regression gate with [`recipes/github-actions/injection-regression.yml`](../recipes/github-actions/injection-regression.yml).

## Run it

```bash
npm install -g a2a-trustgate
a2a signup my-swarm --local
./demo.sh
```

## The commands, by hand

```bash
a2a workspace create "research-swarm"
a2a workspace WS-ID add-agent --name planner --role expert
a2a workspace WS-ID enforce --agent planner "push to production"   # screened vs scope
a2a channel create ops-bus
a2a channel CH-ID send "interface frozen — you're clear to build"  # HMAC-signed
```
