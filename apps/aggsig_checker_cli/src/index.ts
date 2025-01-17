import NDK, { NDKEvent, NDKPrivateKeySigner } from "@nostr-dev-kit/ndk";
import fs from "fs";
import { generateSecretKey } from "nostr-tools";

const OUTPUT_DIR = "out";
const OUTPUT_FILE = `${OUTPUT_DIR}/nostr_events_batch.json`;

interface NostrEventData {
  id: string;
  pubkey: string;
  created_at: number;
  kind: number;
  tags: string[][];
  content: string;
  sig: string;
}

interface CairoParams {
  pk: {
    low: string;
    high: string;
  };
  rx: {
    low: string;
    high: string;
  };
  s: {
    low: string;
    high: string;
  };
  m: {
    low: string;
    high: string;
  };
}

interface BatchEventData {
  nostrEvent: NostrEventData;
  cairoParams: CairoParams;
}

export function splitToU128Pair(hexStr: string): { low: string; high: string } {
  // Remove '0x' prefix if present and pad to 64 characters (32 bytes)
  const paddedHex = hexStr.replace("0x", "").padStart(64, "0");

  // Split into high and low 16 bytes (32 characters each)
  const highHex = paddedHex.slice(0, 32);
  const lowHex = paddedHex.slice(32);

  // Convert to decimal strings
  const high = BigInt("0x" + highHex).toString();
  const low = BigInt("0x" + lowHex).toString();

  return { low, high };
}

function getCairoParams(eventData: NostrEventData): CairoParams {
  // Convert pubkey to cairo params
  const pk = splitToU128Pair(eventData.pubkey);

  // Get signature components (r, s) from the signature
  const sigHex = eventData.sig;
  const r = sigHex.slice(0, 64);
  const s = sigHex.slice(64);

  const rx = splitToU128Pair(r);
  const sParams = splitToU128Pair(s);

  // Get message hash (event id is the hash)
  const m = splitToU128Pair(eventData.id);

  return {
    pk,
    rx,
    s: sParams,
    m,
  };
}

async function generateNostrEventData(index: number): Promise<BatchEventData> {
  const privateKey = generateSecretKey();
  const signer = new NDKPrivateKeySigner(privateKey);
  const ndk = new NDK({ signer });

  const event = new NDKEvent(ndk);
  event.kind = 1;
  event.content = `STARKs x Nostr [${index}]`;
  event.created_at = Math.floor(Date.now() / 1000);
  await event.sign();

  if (!event.sig) {
    throw new Error("Failed to sign event");
  }

  const eventData: NostrEventData = {
    id: event.id,
    pubkey: event.pubkey,
    created_at: event.created_at,
    kind: event.kind,
    tags: event.tags,
    content: event.content,
    sig: event.sig,
  };

  return {
    nostrEvent: eventData,
    cairoParams: getCairoParams(eventData),
  };
}

async function generateBatchEvents(count = 10) {
  const events: BatchEventData[] = [];

  for (let i = 0; i < count; i++) {
    const event = await generateNostrEventData(i);
    events.push(event);
  }

  // Create the output directory if it doesn't exist
  if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
  }

  fs.writeFileSync(OUTPUT_FILE, JSON.stringify(events, null, 2));
  console.log(`${count} events data saved to ${OUTPUT_FILE}`);
}

generateBatchEvents().catch(console.error);
