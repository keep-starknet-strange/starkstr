mod nip01;
mod sha256;
use garaga::definitions::SECP256K1;
use garaga::signatures::schnorr::{SchnorrSignatureWithHint, is_valid_schnorr_signature};
use nip01::hash_challenge;

/// Struct representing a signed Nostr event with hints for the signature verification.
#[derive(Drop, Serde)]
pub struct NostrSignedEvent {
    /// Nostr event's ID (the signed message)
    pub m: u256,
    /// Garaga Schnorr signature with MSM hints, public key, and hash challenge
    pub sig_with_hint: SchnorrSignatureWithHint,
}

// ***************************************
// *********** MAIN ENTRYPOINT ***********
// ***************************************
#[executable]
pub fn main(arguments: Array<felt252>) {
    let mut args = arguments.span();
    let events: Array<NostrSignedEvent> = Serde::deserialize(ref args)
        .expect('Deserialization failed');

    println!("Verifying {} Nostr events signatures...", events.len());

    verify_event_batch(events);

    println!("Signature verification successful");
}

/// Verifies a batch of Nostr events signatures
/// Fails if any of the signatures are invalid
pub fn verify_event_batch(events: Array<NostrSignedEvent>) {
    for event in events {
        let e = hash_challenge(
            event.sig_with_hint.signature.rx, event.sig_with_hint.signature.px, event.m,
        ) % SECP256K1
            .n;
        assert(e == event.sig_with_hint.signature.e, 'Invalid challenge');
        assert(is_valid_schnorr_signature(event.sig_with_hint, 2), 'Invalid signature');
    }
}
