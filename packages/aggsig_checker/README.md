# Aggsig checker package

## Proving

### Install Scarb

We will need a specific Cairo toolchain version:

```
cargo install --git https://github.com/m-kus/scarb --rev 0cb033ba37ed2809eeac59baa169da6c769a241b scarb scarb-execute scarb-cairo-test
```

Make sure it doesn't conflict with the existing Scarb installation.

### Install Stwo prover

Make sure you have the latest Rust nightly toolchain installed.

```sh
RUSTFLAGS="-C target-cpu=native -C opt-level=3" cargo install --git https://github.com/starkware-libs/stwo-cairo adapted_stwo
```

### Prove

Generate execution trace for a sample arguments file:

```sh
scarb run exec-sample
```

Run Stwo prover:

```sh
scarb run prove
```