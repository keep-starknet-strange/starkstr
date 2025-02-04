use anyhow::Result;
use nostr::{EventBuilder, Keys, Kind};
use tracing::info;
use tracing_subscriber::fmt::format::FmtSpan;

const NUM_EVENTS: usize = 1000;

fn main() -> Result<()> {
    // Initialize tracing
    let subscriber = tracing_subscriber::fmt()
        .with_span_events(FmtSpan::ENTER | FmtSpan::CLOSE)
        .finish();
    tracing::subscriber::set_global_default(subscriber).expect("Setting tracing default failed");

    // Generate keys
    let keys = Keys::generate();
    let mut events = Vec::with_capacity(NUM_EVENTS);

    // Generate and sign events
    info!("Generating and signing {} events...", NUM_EVENTS);
    for i in 0..NUM_EVENTS {
        let content = format!("Event content {}", i);
        let event = EventBuilder::new(Kind::TextNote, content)
            .build(keys.public_key())
            .sign_with_keys(&keys)?;
        events.push(event);
    }

    // Verify signatures
    info!("Verifying {} signatures...", NUM_EVENTS);
    let span = tracing::info_span!("verify_signatures");
    let _guard = span.enter();

    for (i, event) in events.iter().enumerate() {
        if !event.verify_signature() {
            panic!("Invalid signature for event {}", i);
        }
    }

    Ok(())
}
