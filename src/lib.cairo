mod types;
mod nostr_aggregate_signature;

use types::NostrSignedEvent;

fn main(events: Array<NostrSignedEvent>) -> u32 {
    println!("Verifying {} Nostr events signatures...", events.len());

    nostr_aggregate_signature::verify_event_batch(events);

    println!("Signature verification successful");
    0
}
