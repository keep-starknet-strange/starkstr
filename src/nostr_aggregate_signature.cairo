use starkstr::types::{U256IntoByteArray, NostrEvent};
use alexandria_math::bip340::{verify};

/// Verifies a batch of Nostr events signatures
/// Fails if any of the signatures are invalid
pub fn verify_event_batch(events: Array<NostrEvent>) {
    for event in events {
        assert!(verify(event.px, event.rx, event.s, event.m.into()));
    }
}
