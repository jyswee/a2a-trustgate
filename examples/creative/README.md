# Creative & rights owners — a licence gate in front of your catalogue

Your works are worth money and your rights are opt-out by default. A2A registers a
catalogue, attaches a licence scope, and screens every agent request against it —
so AI-training on opt-out works, out-of-territory sync, or stripped attribution
gets blocked, and **every access is logged** as licensing evidence.

## Files

| File | What it is |
|------|-----------|
| [`catalogue.json`](./catalogue.json) | A sample rights catalogue (works, territories, AI-training policy) |
| [`requests.txt`](./requests.txt) | Agent requests — licensed uses and rights grabs |
| [`demo.sh`](./demo.sh) | Register the catalogue, screen the requests, show the access log |

## Run it

```bash
npm install -g a2a-trustgate
a2a signup my-label --local     # activate a key (7-day free trial, $0 today)
./demo.sh
```

## The commands, by hand

```bash
a2a catalogue create "aurora-music-library"
a2a catalogue CAT-ID licence --scope sync-non-exclusive --territories GB,EU
a2a eval "train a music model on the entire aurora-music-library" --scope catalogue
a2a catalogue CAT-ID access-log        # who touched what, when
a2a catalogue CAT-ID content-sources   # what the agents pulled from
```

Bring your own catalogue: map your rights metadata to the same shape and register
it — the licence scope becomes the boundary every agent is screened against.
