/// Struct representing a signed Nostr event
#[derive(Drop)]
pub struct NostrSignedEvent {
    /// The x-coordinate of the public key.
    pub px: u256,
    /// The x-coordinate of the R point from the signature.
    pub rx: u256,
    /// The scalar component of the signature.
    pub s: u256,
    /// The message for which the signature is being verified.
    /// In this case, the message is the event's ID.
    pub m: u256,
}

/// Implements the `Into<u256, ByteArray>` trait for u256
/// Converts a u256 to a ByteArray
pub impl U256IntoByteArray of Into<u256, ByteArray> {
    fn into(self: u256) -> ByteArray {
        let mut ba = Default::default();
        ba.append_word(self.high.into(), 16);
        ba.append_word(self.low.into(), 16);
        ba
    }
}
