# EU AI Act — where an agent audit trail helps

A practical crosswalk from selected **EU AI Act** obligations for high-risk AI
systems to the controls an agent-screening + audit layer provides. This is an
engineering aid, **not legal advice** — confirm scope and applicability with your
compliance team.

| EU AI Act (Reg. 2024/1689) | Obligation, in brief | How an agent gate + audit trail helps |
|---|---|---|
| **Art. 12 — Record-keeping** | High-risk systems must automatically log events over their lifetime for traceability. | Every screening decision (allow/block/review) is written append-only with actor, action, verdict, reasoning and timestamp — exportable as CSV/JSON. |
| **Art. 14 — Human oversight** | Systems must be designed so humans can oversee and intervene. | The approvals queue puts sensitive actions in front of a human (`a2a approvals` → approve/reject with a recorded reason). |
| **Art. 13 — Transparency** | Operation must be sufficiently transparent for deployers to interpret output. | Each decision carries a human-readable reason; the audit export is inspectable end-to-end. |
| **Art. 15 — Accuracy, robustness, cybersecurity** | Resilience against errors and adversarial manipulation. | Deterministic + behavioural screening blocks destructive ops and injection patterns before they execute. |
| **Art. 26 — Deployer obligations** | Deployers must monitor operation and keep logs. | Continuous screening + retained, exportable logs support ongoing monitoring. |
| **Art. 72 — Post-market monitoring** | Providers must actively collect and review operational data. | The audit stream is the operational-data source; export on a schedule for review. |

## OCSF alignment

The audit export is shaped to the **Open Cybersecurity Schema Framework (OCSF)** so
it drops into a SIEM (Splunk, Sentinel, Elastic) alongside the rest of your security
telemetry — see [`sample-audit.ocsf.json`](./sample-audit.ocsf.json) for the shape.

## Produce an auditor-ready export

```bash
a2a audit export --format csv   > audit.csv
a2a audit export --format json  > audit.json
```

## Related standards (non-exhaustive)

- **NIST AI RMF** — Govern / Map / Measure / Manage: the audit trail is a Measure/Manage artefact.
- **ISO/IEC 42001** — AI management systems: operational logging + human oversight controls.
- **SOC 2 (CC7)** — monitoring of controls: screening decisions as control evidence.
