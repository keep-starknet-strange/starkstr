mod types;
mod nostr_aggregate_signature;

use types::NostrEvent;

fn main(events: Array<NostrEvent>) -> u32 {
    println!("Verifying {} Nostr events signatures...", events.len());

    nostr_aggregate_signature::verify_event_batch(events);

    println!("Signature verification successful");
    0
}
