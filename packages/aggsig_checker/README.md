# Aggsig checker package

## Proving

### Install Scarb

We will need a specific Cairo toolchain version:

```
cargo install --git https://github.com/m-kus/scarb --rev 52333082349b6991c8a21517fa2d4c27f9d82ab6 scarb
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