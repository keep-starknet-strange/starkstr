mod nip01;
mod schnorr;
mod sha256;
use garaga::definitions::SECP256K1;
use garaga::ec_ops::{DerivePointFromXHint, MSMHint};
use nip01::hash_challenge;
use schnorr::verify_schnorr;

/// Struct representing a signed Nostr event with hints for the signature verification.
#[derive(Drop, Serde)]
pub struct NostrSignedEvent {
    /// Nostr event's ID (the signed message)
    pub m: u256,
    /// The x-coordinate of the public key.
    pub px: u256,
    /// The y-coordinate of the public key (hint).
    pub py: u256,
    /// The x-coordinate of the R point from the signature.
    pub rx: u256,
    /// The scalar component of the signature.
    pub s: u256,
    /// MSM hint for the signature verification.
    pub msm_hint: MSMHint,
    /// EC point derive hint for the signature verification.
    pub msm_derive_hint: DerivePointFromXHint,
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
        let e = hash_challenge(event.rx, event.px, event.m) % SECP256K1.n;
        verify_schnorr(
            event.rx, event.s, e, event.px, event.py, event.msm_hint, event.msm_derive_hint,
        );
    }
}
