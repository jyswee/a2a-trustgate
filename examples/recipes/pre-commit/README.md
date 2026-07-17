# Recipe — screen staged commands before they commit

A git `pre-commit` hook that runs added shell lines through the gate and **blocks the
commit if anything is blocked**. Local guardrail for agent-authored changes.

## Install

```bash
cp examples/recipes/pre-commit/pre-commit .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

Needs `a2a` (`npm install -g a2a-trustgate`) + an activated key.

## What it does

- Reads the added (`+`) lines from staged `*.sh` files.
- Runs each through `a2a eval`.
- If any line is **blocked** (exit 1), the commit is stopped.
- Override with `git commit --no-verify` (not recommended).

Screening only inspects — nothing is executed.
