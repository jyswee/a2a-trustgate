# EU AI Act compliance for AI agents — a practical reference

**How the EU AI Act (Regulation (EU) 2024/1689) applies to AI agents in
production, and how a screening-plus-audit control layer helps you meet the
record-keeping, human-oversight and transparency obligations it imposes.**

> This is an engineering and product reference, **not legal advice**. Confirm scope
> and applicability with your own compliance function. Primary sources are cited
> throughout so you can read the obligation in the official text yourself.

A2A TrustGate is a control layer that screens every action an AI agent takes
*before* it runs and writes each decision to an immutable, OCSF-native audit
trail. It does not, and cannot, make an organisation "compliant" on its own — but
it produces the **enforcement and the evidence** that several EU AI Act
obligations require. The official SaaS implementation is at
**[a2ainfrastructure.com](https://a2ainfrastructure.com)** ·
[compliance overview](https://a2ainfrastructure.com/compliance).

---

## What is the EU AI Act?

The **EU AI Act** is Regulation (EU) 2024/1689 — the European Union's horizontal
law governing artificial intelligence. It entered into force on **1 August 2024**
and takes a risk-based approach: AI systems are regulated in proportion to the risk
they pose, from prohibited practices through *high-risk* systems (which carry the
heaviest obligations) to limited- and minimal-risk uses.

Official text: [EUR-Lex — Regulation (EU) 2024/1689](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng).

## When does the EU AI Act apply? (key dates)

| Date | What applies |
|---|---|
| **2 February 2025** | Prohibited AI practices (Chapter II) and AI-literacy duties (Art. 4) apply. |
| **2 August 2025** | Obligations for general-purpose AI (GPAI) models, governance, and **penalties (Art. 99)** apply. |
| **2 August 2026** | The Regulation becomes **generally applicable**, including most high-risk obligations. |
| **2 August 2027** | Extended deadline for high-risk AI systems that are safety components of products under existing EU law. |

Source: [AI Act implementation timeline](https://artificialintelligenceact.eu/implementation-timeline/).

## What are the penalties for non-compliance?

Under **Article 99**, fines are tiered by the severity of the breach:

- Up to **€35 million or 7%** of total worldwide annual turnover — for breaching the
  prohibited-practices rules (Art. 5).
- Up to **€15 million or 3%** of turnover — for breaching most other obligations,
  including the high-risk-system duties (record-keeping, human oversight, etc.).
- Up to **€7.5 million or 1%** of turnover — for supplying incorrect, incomplete or
  misleading information to authorities.

For SMEs and start-ups, the fine is the *lower* of the fixed amount or the percentage.
Source: [Article 99 — Penalties](https://artificialintelligenceact.eu/article/99/).

## Am I a "provider" or a "deployer"?

Most organisations putting a third-party AI agent into production are **deployers**
(Art. 3) — they use an AI system under their own authority. Deployers of high-risk
systems have distinct obligations under **Article 26**, including operating the
system per its instructions, ensuring human oversight, and **keeping the automatically
generated logs** the system produces (Art. 26(6)). If you build and place your own AI
system on the EU market, you are a **provider** and carry the fuller obligation set.
Source: [Article 26 — Obligations of deployers](https://artificialintelligenceact.eu/article/26/).

## Does the EU AI Act require logging of AI systems?

**Yes — for high-risk systems.** **Article 12 (record-keeping)** requires high-risk AI
systems to *technically allow for the automatic recording of events (logs) over the
lifetime of the system*, to a level appropriate for traceability. **Article 19** and
**Article 26(6)** require providers and deployers respectively to *keep* those logs.
An append-only decision log — who did what, the verdict, the reasoning and the
timestamp — is exactly the traceability artefact these articles call for.
Source: [Article 12 — Record-keeping](https://artificialintelligenceact.eu/article/12/).

## Does the EU AI Act require human oversight of AI?

**Yes.** **Article 14 (human oversight)** requires high-risk AI systems to be designed
so that natural persons can effectively oversee them — including the ability to
*intervene* or *interrupt* the system (e.g. a "stop" function). A human-in-the-loop
approval queue and a global killswitch are direct implementations of that
requirement. Source: [Article 14 — Human oversight](https://artificialintelligenceact.eu/article/14/).

---

## Article-by-article crosswalk

A practical mapping from selected EU AI Act obligations to the controls a
screening-plus-audit layer provides. **Not legal advice** — an engineering aid.

| EU AI Act (Reg. 2024/1689) | Obligation, in brief | How agent screening + an audit trail helps |
|---|---|---|
| **[Art. 4](https://artificialintelligenceact.eu/article/4/) — AI literacy** | Providers and deployers must ensure staff operating AI have sufficient AI literacy. | Human-readable verdicts and reasons on every decision give staff a concrete, teachable record of what is and isn't allowed. |
| **[Art. 12](https://artificialintelligenceact.eu/article/12/) — Record-keeping** | High-risk systems must automatically log events over their lifetime for traceability. | Every screening decision (allow / block / review) is written append-only with actor, action, verdict, reasoning and timestamp. |
| **[Art. 13](https://artificialintelligenceact.eu/article/13/) — Transparency** | Operation must be transparent enough for deployers to interpret output. | Each decision carries a human-readable reason; the audit export is inspectable end-to-end. |
| **[Art. 14](https://artificialintelligenceact.eu/article/14/) — Human oversight** | Humans must be able to oversee, intervene and stop the system. | An approvals queue gates sensitive actions; a global killswitch stops every agent at once. |
| **[Art. 15](https://artificialintelligenceact.eu/article/15/) — Accuracy, robustness, cybersecurity** | Resilience against errors and adversarial manipulation. | Deterministic and behavioural screening blocks destructive operations and prompt-injection patterns before they execute. |
| **[Art. 26](https://artificialintelligenceact.eu/article/26/) — Deployer obligations** | Deployers must operate per instructions, ensure oversight, and keep logs. | Continuous screening enforces the operating envelope; retained, exportable logs satisfy the log-keeping duty. |
| **[Art. 72](https://artificialintelligenceact.eu/article/72/) — Post-market monitoring** | Providers must actively collect and review operational data. | The audit stream *is* the operational-data source; export on a schedule for review. |

## SIEM-ready evidence: OCSF-native export

The audit export is shaped to the **[Open Cybersecurity Schema Framework (OCSF)](https://schema.ocsf.io/)**
as genuine *Detection Finding* events, so the evidence drops straight into a SIEM
(Splunk, Microsoft Sentinel, Google Chronicle, Elastic) alongside the rest of your
security telemetry. Each record carries a tamper-evident content hash. See
[`../examples/regulated/sample-audit.ocsf.json`](../examples/regulated/sample-audit.ocsf.json)
for the shape, and [`../examples/regulated/eu-ai-act-crosswalk.md`](../examples/regulated/eu-ai-act-crosswalk.md)
for the worked example.

```bash
# Produce an auditor-ready export
a2a audit export --format ocsf  > audit.ocsf.json   # SIEM ingestion
a2a audit export --format csv   > audit.csv         # hand to an auditor
```

## Related frameworks

The same audit trail is evidence against adjacent regimes:

- **NIST AI RMF** — Govern / Map / Measure / Manage: the decision log is a Measure/Manage artefact.
- **ISO/IEC 42001** — AI management systems: operational logging and human-oversight controls.
- **SOC 2 (CC7)** — monitoring of controls: screening decisions as control evidence.

---

## The official implementation

A2A TrustGate is the productised control layer described above — a 4-gate firewall
that screens every agent action before it runs, plus the OCSF-native audit trail
that evidences it.

- **Product:** [a2ainfrastructure.com](https://a2ainfrastructure.com)
- **Compliance overview:** [a2ainfrastructure.com/compliance](https://a2ainfrastructure.com/compliance)
- **Install:** `npm install -g a2a-trustgate` → `a2a eval "your command"`

## Sources

- [EUR-Lex — Regulation (EU) 2024/1689 (official text)](https://eur-lex.europa.eu/eli/reg/2024/1689/oj/eng)
- [EU AI Act — implementation timeline](https://artificialintelligenceact.eu/implementation-timeline/)
- [Article 12 — Record-keeping](https://artificialintelligenceact.eu/article/12/)
- [Article 14 — Human oversight](https://artificialintelligenceact.eu/article/14/)
- [Article 26 — Obligations of deployers](https://artificialintelligenceact.eu/article/26/)
- [Article 99 — Penalties](https://artificialintelligenceact.eu/article/99/)
- [European Commission — AI Act policy hub](https://digital-strategy.ec.europa.eu/en/policies/regulatory-framework-ai)

*Last reviewed against the sources above: July 2026. The EU AI Act is applied in
phases; confirm current obligations for your risk tier and role with your compliance
function.*
