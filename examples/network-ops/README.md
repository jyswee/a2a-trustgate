# Network operations — a gate in front of every device

Your agents run commands against routers, switches, and firewalls. A2A registers
each device, enforces a per-device policy, screens every command, and gives you a
killswitch that freezes every agent at once.

## Files

| File | What it is |
|------|-----------|
| [`hosts.csv`](./hosts.csv) | 7 sample devices (`name,host,vendor,model,role,siteCode`) for bulk import |
| [`commands.txt`](./commands.txt) | A batch of device commands — routine, sensitive, and dangerous |
| [`policy.example.json`](./policy.example.json) | A strict per-device policy template |
| [`demo.sh`](./demo.sh) | Onboard the fleet, screen the batch, show the killswitch |

## Run it

```bash
npm install -g a2a-trustgate
a2a signup my-noc --local     # activate a key (7-day free trial, $0 today)
./demo.sh
```

## The commands, by hand

```bash
a2a device import --file hosts.csv       # bulk onboard
a2a device add --name core-rtr-1 --host 10.0.0.1 --vendor cisco
a2a device policy DEVICE-ID --mode strict --require-approval --max 5
a2a device lock DEVICE-ID                # freeze a single device
a2a killswitch                           # freeze EVERY agent, everywhere
a2a eval "erase startup-config"          # screen a command (exit 0/1/2)
```

Bring your own inventory: export your CMDB/NetBox to the same CSV columns and
`a2a device import --file your-hosts.csv`.
