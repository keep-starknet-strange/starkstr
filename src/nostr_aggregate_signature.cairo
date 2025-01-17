use starkstr::types::{U256IntoByteArray, NostrSignedEvent};
use alexandria_math::bip340::{verify};

/// Verifies a batch of Nostr events signatures
/// Fails if any of the signatures are invalid
pub fn verify_event_batch(events: Array<NostrSignedEvent>) {
    for event in events {
        assert!(verify(event.px, event.rx, event.s, event.m.into()));
    }
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn given_valid_signed_events_when_batch_verification_then_succeeds() {
        let events = array![
            NostrSignedEvent {
                px: 0xc44f2be1b2fb5371330386046e60207bbd84938d4812ee0c7a3c11be605a7585,
                rx: 0x6c398fa11543400a10c1934fb2a28b3f39f78bd87a2d13a060987f39a094c691,
                s: 0xd82dbd95a20628a376fb337603cbb1cd8de7887c85e38ed029380c9e0bbf076d,
                m: 0xd2a97d43cd09bc89c97b77d3555a5c72a8650ca86605cbd4b663dc3d412048fa,
            },
            NostrSignedEvent {
                px: 0xc44f2be1b2fb5371330386046e60207bbd84938d4812ee0c7a3c11be605a7585,
                rx: 0xc48f9e7cf3045d4a08dc35c82d6d797c86db3c3e23d4b99e457f4af3aad0d004,
                s: 0xb8baff77c297b8b87be25704795457f2d9763493f359b2aa16ce321df8b93fcd,
                m: 0xdc2675b686a7a43bac0cb26d82744bf26a5fce51c2de6e9bfa9bfc603e5d2327,
            },
        ];
        verify_event_batch(events);
    }
}
