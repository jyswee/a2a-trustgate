# A2A TrustGate — agent-safety corpus

An open, labelled benchmark of **dangerous vs. benign agent actions** and
**prompt-injection strings**, each with an expected verdict. Point it at the A2A
TrustGate firewall (or your own guardrail) and score how well it agrees.

Think of it as the AI-safety equivalent of a spam corpus: a shared set of *inputs
with ground-truth labels* you can run any screener against.

## What's here

| File | Rows | Shape |
|------|------|-------|
| [`commands.jsonl`](./commands.jsonl) | 35 | shell/API/infra/db actions — `{command, category, expected, why}` |
| [`prompt-injections.jsonl`](./prompt-injections.jsonl) | 20 | jailbreak / injection strings — `{text, technique, expected, why}` |
| [`run.sh`](./run.sh) | — | replay a dataset through `a2a eval` and score it |

`expected` is one of **`allow`** · **`block`** · **`review`**, matching the CLI's
exit codes (`0` / `1` / `2`).

## Score it in 30 seconds

```bash
npm install -g a2a-trustgate
a2a signup my-lab --local          # activate a key (7-day free trial, $0 today)

cd examples/corpus
./run.sh                            # scores commands.jsonl against the live gate
./run.sh prompt-injections.jsonl    # scores the injection set
```

You'll get a per-row ✓/✗ and an overall agreement score, plus a list of any
disagreements to eyeball.

## Use it as data (no account needed)

The `.jsonl` files are useful on their own — clone the repo and feed them to
**your** guardrail, a model eval in promptfoo/garak, or a unit-test suite:

```bash
# how many of each verdict does the corpus expect?
cat commands.jsonl | node -e 'let a={};require("readline").createInterface({input:process.stdin}).on("line",l=>{if(l.trim()){const e=JSON.parse(l).expected;a[e]=(a[e]||0)+1}}).on("close",()=>console.log(a))'
```

## Categories covered

Filesystem destruction · secret exfiltration · pipe-to-shell remote execution ·
supply-chain installs · destructive database/schema ops · production-infra deletes ·
firewall/permission changes · fork-bombs · container escapes · financial API calls —
and, for prompts: instruction-override, jailbreak personas, encoding/unicode evasion,
markup smuggling, data-exfil-in-content, tool injection, and coercion.

## Contributing

Found a bypass or a mislabel? Open an issue or PR with a new `.jsonl` row in the
same shape. Real-world agent near-misses (sanitised) are especially welcome — a
shared corpus makes every screener better.

## Notes

- This corpus is **inputs and expected labels only**. It does not contain, and is
  not derived from, the firewall's internal rules — you can run it against any
  screener you like.
- Verdicts can legitimately differ from the labels depending on context you pass
  (`--context`, `--scope`, tenant policy). Disagreements are a starting point for
  review, not automatic failures.
- Licence: the datasets in this folder are provided for evaluation and testing.
  See the repo [LICENSE](../../LICENSE).
