use stwo_cairo_air::{CairoProof, CairoClaim, CairoInteractionClaim, verify_cairo};
use stwo_verifier_core::verifier::StarkProof;

#[executable]
fn main(args: Array<felt252>) {
    let mut args = args.span();

    let claim: CairoClaim = Serde::deserialize(ref args).expect('cairo claim');
    let interaction_claim: CairoInteractionClaim = Serde::deserialize(ref args).expect('cairo interaction claim');
    let stark_proof: StarkProof = Serde::deserialize(ref args).expect('stark proof');

    // print!("Verifying proof...");
    // if let Result::Err(err) = verify_cairo(proof) {
    //     panic!("Verification failed: {:?}", err);
    // }
    // println!("Verification successful");
}
