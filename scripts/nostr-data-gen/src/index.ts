import NDK, { NDKEvent, NDKPrivateKeySigner } from "@nostr-dev-kit/ndk";

import fs from "fs";

const OUTPUT_DIR = "out";
const OUTPUT_FILE = `${OUTPUT_DIR}/sample-signed-event.json`;

async function generateNostrEventData() {
  const privateKey =
    "0277cc53c89ca9c8a441987265276fafa55bf5bed8a55b16fd640e0d6a0c21e2";
  const signer = new NDKPrivateKeySigner(privateKey);
  const ndk = new NDK({ signer });

  const event = new NDKEvent(ndk);
  event.kind = 1;
  event.content = "Hello from Nostr!";
  // Hardcoded for now
  event.created_at = 1737047299;
  await event.sign();

  const eventData = {
    id: event.id,
    pubkey: event.pubkey,
    created_at: event.created_at,
    kind: event.kind,
    tags: event.tags,
    content: event.content,
    sig: event.sig,
  };

  // Create the output directory if it doesn't exist
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(eventData, null, 2));
  console.log("Event data saved to event.json");
  console.log("Event data:", eventData);
}

generateNostrEventData().catch(console.error);
