use stwo_cairo_air::{CairoProof, verify_cairo};

#[executable]
fn main(proof: CairoProof) {
    print!("Verifying proof...");
    if let Result::Err(err) = verify_cairo(proof) {
        panic!("Verification failed: {:?}", err);
    }
    println!("Verification successful");
}