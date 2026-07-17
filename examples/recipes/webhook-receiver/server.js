// Minimal A2A webhook receiver — verify the HMAC signature, then act on the event.
//
// A2A signs every webhook with HMAC-SHA256 over the raw request body, using your
// endpoint's signing secret. Verify it before you trust the payload.
//
//   node server.js            # listens on :8099
//   Set A2A_WEBHOOK_SECRET to your endpoint's signing secret.
//
// Register the endpoint:  a2a webhooks add --url https://you.example.com/a2a/webhook

const http = require("http");
const crypto = require("crypto");

const SECRET = process.env.A2A_WEBHOOK_SECRET || "";
const PORT = process.env.PORT || 8099;

// Constant-time compare of the signature header against a fresh HMAC of the body.
function verify(rawBody, signatureHeader) {
  if (!SECRET || !signatureHeader) return false;
  const expected = crypto.createHmac("sha256", SECRET).update(rawBody).digest("hex");
  const a = Buffer.from(expected);
  const b = Buffer.from(String(signatureHeader));
  return a.length === b.length && crypto.timingSafeEqual(a, b);
}

http
  .createServer((req, res) => {
    if (req.method !== "POST") {
      res.writeHead(405).end("method not allowed");
      return;
    }
    const chunks = [];
    req.on("data", (c) => chunks.push(c));
    req.on("end", () => {
      const raw = Buffer.concat(chunks);
      const sig = req.headers["x-a2a-signature"];
      if (!verify(raw, sig)) {
        res.writeHead(401).end("invalid signature");
        return;
      }
      const event = JSON.parse(raw.toString("utf8"));
      // Your logic here. Example: react to a blocked action.
      if (event.type === "screening.blocked") {
        console.log(`BLOCKED  ${event.data?.command} — ${event.data?.reason}`);
      } else {
        console.log(`event    ${event.type}`);
      }
      res.writeHead(200).end("ok");
    });
  })
  .listen(PORT, () => console.log(`A2A webhook receiver on :${PORT}`));
