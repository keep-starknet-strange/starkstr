use core::circuit::u384;
use core::traits::DivRem;
use crate::sha256::compute_sha256_u32_array;

const TWO_POW_32: u128 = 0x100000000;
const TWO_POW_64: u128 = 0x10000000000000000;
const TWO_POW_96: u128 = 0x1000000000000000000000000;

/// Computes BIP0340/challenge tagged hash for Nostr event ID.
///
/// # Arguments:
/// * `rx`: `u256` - The x-coordinate of the R point from the signature.
/// * `px`: `u256` - The x-coordinate of the public key.
/// * `m`:  `u256` - The Nostr event ID.
///
/// # Returns:
/// * `u256` - `sha256(tag) || sha256(tag) || bytes(rx) || bytes(px) || m` as u256
///    where tag = "BIP0340/challenge".
pub fn hash_challenge(rx: u384, px: u384, m: u256) -> u256 {
    let mut input: Array<u32> = array![
        // sha256(tag)
        0x7bb52d7a,
        0x9fef5832,
        0x3eb1bf7a,
        0x407db382,
        0xd2f3f2d8,
        0x1bb1224f,
        0x49fe518f,
        0x6d48d37c,
        // sha256(tag)
        0x7bb52d7a,
        0x9fef5832,
        0x3eb1bf7a,
        0x407db382,
        0xd2f3f2d8,
        0x1bb1224f,
        0x49fe518f,
        0x6d48d37c,
    ];

    let rx: u256 = rx.try_into().expect('rx u256 cast');
    let px: u256 = px.try_into().expect('px u256 cast');

    append_u256(ref input, rx);
    append_u256(ref input, px);
    append_u256(ref input, m);

    let hash = compute_sha256_u32_array(input, 0, 0);
    u256_from_array(hash)
}

fn append_u128(ref out: Array<u32>, val: u128) {
    let (q0, r0) = DivRem::div_rem(val, 0x100000000);
    let (q1, r1) = DivRem::div_rem(q0, 0x100000000);
    let (q2, r2) = DivRem::div_rem(q1, 0x100000000);
    out.append(q2.try_into().unwrap());
    out.append(r2.try_into().unwrap());
    out.append(r1.try_into().unwrap());
    out.append(r0.try_into().unwrap());
}

fn append_u256(ref out: Array<u32>, val: u256) {
    append_u128(ref out, val.high);
    append_u128(ref out, val.low);
}

fn u256_from_array(arr: [u32; 8]) -> u256 {
    let [a0, a1, a2, a3, a4, a5, a6, a7] = arr;
    u256 {
        high: a0.into() * TWO_POW_96 + a1.into() * TWO_POW_64 + a2.into() * TWO_POW_32 + a3.into(),
        low: a4.into() * TWO_POW_96 + a5.into() * TWO_POW_64 + a6.into() * TWO_POW_32 + a7.into(),
    }
}
