# Recipe — verify A2A webhooks (HMAC)

A2A signs every webhook with **HMAC-SHA256** over the raw request body, in the
`X-A2A-Signature` header. This ~40-line receiver verifies that signature before
trusting the payload — so a spoofed event can't drive your automation.

## Run it

```bash
export A2A_WEBHOOK_SECRET="whsec_…"      # your endpoint's signing secret
node server.js                           # listens on :8099
```

Register the endpoint so A2A sends events to it:

```bash
a2a webhooks add --url https://you.example.com/a2a/webhook
```

## How verification works

1. Read the **raw** body (do not re-serialize — signatures are over the exact bytes).
2. Compute `HMAC_SHA256(secret, rawBody)` as hex.
3. Constant-time compare against the `X-A2A-Signature` header.
4. Only parse + act on the event if they match; otherwise return `401`.

Example handler reacts to a `screening.blocked` event — swap in your own logic
(page on-call, open a ticket, freeze an agent with `a2a killswitch`).
