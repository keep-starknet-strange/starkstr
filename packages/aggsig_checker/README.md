# Aggsig checker package

## Proving

### Install Scarb

We will need a specific Cairo toolchain version:

```
make install-scarb
```

Make sure it doesn't conflict with the existing Scarb installation.

### Install Stwo prover

Make sure you have the latest Rust nightly toolchain installed.

```sh
make install-stwo
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
