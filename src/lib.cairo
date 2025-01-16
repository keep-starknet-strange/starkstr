use alexandria_math::bip340::{verify};

use core::byte_array::ByteArrayTrait;

impl U256IntoByteArray of Into<u256, ByteArray> {
    fn into(self: u256) -> ByteArray {
        let mut ba = Default::default();
        ba.append_word(self.high.into(), 16);
        ba.append_word(self.low.into(), 16);
        ba
    }
}

fn main() -> u32 {
    println!("Yo, Nostr!");

    // Verify a Schnorr signature
    // https://github.com/bitcoin/bips/blob/master/bip-0340/test-vectors.json
    let px: u256 = 0xdff1d77f2a671c5f36183726db2341be58feae1da2deced843240f7b502ba659;
    let rx: u256 = 0x6896bd60eeae296db48a229ff71dfe071bde413e6d43f917dc8dcf8c78de3341;
    let s: u256 = 0x8906d11ac976abccb20b091292bff4ea897efcb639ea871cfa95f6de339e4b0a;
    let m: u256 = 0x243f6a8885a308d313198a2e03707344a4093822299f31d0082efa98ec4e6c89;
    assert!(verify(px, rx, s, m.into()));
    0
}
