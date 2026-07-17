# University & research — a gate across every campus silo

A university is not one workload. Research agents must stay inside what the grant
funded and the ethics committee approved; the registrar must not leak student
**education records**; and AI must not ghost-write submitted **coursework**. One
A2A gate screens all three silos and lands every decision on a review-ready trail.

- **Research** — each **grant is a scope**; anything the approval doesn't cover
  (re-identification, un-consented contact, out-of-scope linkage) is blocked.
- **Student records** — disclosing education records to a third party without
  consent is blocked (FERPA / UK-GDPR); any movement is held for review.
- **Academic integrity** — ghost-writing work *for submission* and evading
  plagiarism / AI-detection are blocked; genuine study aids are allowed.

(Universities also inherit the campus-IT device gate, the library TDM opt-out, and
PHI/PCI DLP for health & bursar — the same controls the other kits demonstrate.)

## Files

| File | What it is |
|------|-----------|
| [`grants.json`](./grants.json) | Sample research grants as agent scopes (scope + ethics approval) |
| [`actions.txt`](./actions.txt) | Research-agent actions — in-scope work and out-of-scope breaches |
| [`student-records.txt`](./student-records.txt) | FERPA / UK-GDPR — education-record disclosure |
| [`coursework.txt`](./coursework.txt) | QAA / academic integrity — AI-in-coursework |
| [`ethics-crosswalk.md`](./ethics-crosswalk.md) | UKRI / REC / QAA / UK-GDPR expectations → the controls |
| [`demo.sh`](./demo.sh) | Screen all three silos, produce an ethics export |

## Run it

```bash
npm install -g a2a-trustgate
a2a signup my-lab --local     # activate a key (7-day free trial, $0 today)
./demo.sh
```

## The commands, by hand

```bash
a2a eval "re-identify patients by cross-referencing postcodes and DOB" --scope UKRI-EP-2026-0417
a2a eval "run a regression on the de-identified clinical cohort"       --scope UKRI-EP-2026-0417
a2a audit export --format csv  > ethics-audit.csv     # review-ready evidence
```

> Education pricing: the **Institutional** plan is available to universities and
> research bodies. Engineering aid, **not a substitute for your REC/IRB process.**
