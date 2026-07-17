# Research ethics — where an agent scope + audit trail helps

A practical crosswalk from UK research-governance expectations to the controls a
grant-scoped agent gate + audit trail provides. This is an engineering aid, **not a
substitute for your REC/IRB process** — confirm with your research ethics committee.

| Framework | Expectation, in brief | How a grant-scoped gate + audit trail helps |
|---|---|---|
| **UKRI** grant conditions | Data used only for the funded purpose, within the approved scope. | Each grant is an agent **scope**; actions outside it (`--scope UKRI-…`) are blocked before they run. |
| **REC / IRB ethics approval** | Work must stay within what the ethics committee approved. | The grant records its `ethicsApproval`; re-identification, un-consented contact, and out-of-scope linkage are denied. |
| **QAA** academic integrity | AI must not produce submitted work or defeat originality checks. | Ghost-writing *for submission* and plagiarism / AI-detection evasion are blocked; genuine study aids (proofread, explain, cite) are allowed. Every decision is logged. |
| **FERPA / UK GDPR** (education records) | Student records not disclosed to third parties without consent. | Disclosing transcripts / grades / disciplinary records to an external party or third-party AI is blocked; any movement is held for review; consented / anonymised handling is allowed. |
| **UK GDPR** (research provisions) | Data minimisation; special-category data safeguards. | De-identified-only / consented-only scopes enforce minimisation at the point of action. |
| **Concordat to Support Research Integrity** | Institutions must evidence good practice. | The audit export is the evidence: who did what, under which grant, with what verdict. |

## Produce a review-ready export

```bash
a2a audit export --format csv  > ethics-audit.csv
a2a audit export --format json > ethics-audit.json
```

## Related standards (non-exhaustive)

- **NIST AI RMF** — Govern / Map / Measure / Manage.
- **ISO/IEC 42001** — AI management systems: logging + oversight.
- **EU AI Act** — see the [`regulated/` crosswalk](../regulated/eu-ai-act-crosswalk.md) for high-risk-system obligations.
