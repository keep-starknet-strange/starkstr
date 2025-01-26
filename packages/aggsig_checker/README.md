# Aggsig checker package

## Proving

### Install Scarb

We will need a specific Cairo toolchain version:

```
cargo install --git https://github.com/m-kus/scarb --rev 2b2e7c1ab558f022ef69ef0e1d9ccaac6cebb8fc scarb scarb-execute scarb-cairo-test scarb-cairo-run scarb-cairo-language-server
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
make execute
```

Run Stwo prover:

```sh
make prove
```

The command will generate a proof and verify it locally.
