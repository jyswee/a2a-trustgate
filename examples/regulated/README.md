# Regulated — every decision on an append-only audit trail

Finance, healthcare, and public-sector deployments have to *prove* what an agent was
allowed to do. A2A screens each action (allow / block / review, with a reason) and
writes every decision to an append-only trail you export for an auditor — as genuine
**OCSF Detection Findings** (class 2004) that drop straight into your SIEM with no
custom parser.

## Files

| File | What it is |
|------|-----------|
| [`commands.txt`](./commands.txt) | A batch of regulated-environment actions — routine and dangerous |
| [`eu-ai-act-crosswalk.md`](./eu-ai-act-crosswalk.md) | EU AI Act obligations → the controls a gate + audit trail provides |
| [`sample-audit.ocsf.json`](./sample-audit.ocsf.json) | One exported row — a genuine OCSF Detection Finding [2004] |
| [`demo.sh`](./demo.sh) | Screen the batch, then produce an auditor-ready export |

## Run it

```bash
npm install -g a2a-trustgate
a2a signup my-bank --local     # activate a key (7-day free trial, $0 today)
./demo.sh
```

## The commands, by hand

```bash
a2a eval "DELETE FROM audit_log WHERE id < 10000"   # screened → block, with a reason
a2a approvals                                        # human oversight queue (Art. 14)
a2a audit export --format csv    > audit.csv         # auditor-ready spreadsheet
a2a audit export --format json   > audit.json        # OCSF Detection Findings (envelope)
a2a audit export --format ndjson > audit.ndjson      # one OCSF finding per line, for SIEM ingest
```

Every screening — allow *or* block, with its reasoning — lands in the trail. The
export is the evidence: who, what, verdict, reason, timestamp.

> Engineering aid, **not legal advice** — confirm scope with your compliance team.
