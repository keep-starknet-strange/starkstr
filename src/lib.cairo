use alexandria_math::bip340::{verify};

mod fmt_utils;

use fmt_utils::U256IntoByteArray;

// fn main(px: u256, rx: u256, s: u256, m: u256) -> u32 {
fn main() -> u32 {
    println!("Verifying Nostr event signature...");

    test_with_hardcoded_values();

    // TODO: Uncomment this once we have the values from the Nostr event as arguments of the main
    // function
    //assert!(verify(px, rx, s, m.into()));

    println!("Signature verification successful");
    0
}

fn test_with_hardcoded_values() {
    // pubkey: "c44f2be1b2fb5371330386046e60207bbd84938d4812ee0c7a3c11be605a7585"
    let px: u256 = 0xc44f2be1b2fb5371330386046e60207bbd84938d4812ee0c7a3c11be605a7585;

    // sig:
    // "6c398fa11543400a10c1934fb2a28b3f39f78bd87a2d13a060987f39a094c691d82dbd95a20628a376fb337603cbb1cd8de7887c85e38ed029380c9e0bbf076d"
    // First 64 chars of sig is rx, last 64 chars is s
    let rx: u256 = 0x6c398fa11543400a10c1934fb2a28b3f39f78bd87a2d13a060987f39a094c691;
    let s: u256 = 0xd82dbd95a20628a376fb337603cbb1cd8de7887c85e38ed029380c9e0bbf076d;

    // id (message hash): "d2a97d43cd09bc89c97b77d3555a5c72a8650ca86605cbd4b663dc3d412048fa"
    let m: u256 = 0xd2a97d43cd09bc89c97b77d3555a5c72a8650ca86605cbd4b663dc3d412048fa;
    assert!(verify(px, rx, s, m.into()));
}
