# Aggsig checker package

This package contains the Cairo implementation of a program that verifies a batch of Nostr events.

## Prerequisites

- [Rust nightly toolchain](https://www.rust-lang.org/tools/install)
- [Python 3.10](https://www.python.org/downloads/) ([pyenv](https://github.com/pyenv/pyenv) recommended)
- [Scarb](https://docs.swmansion.com/scarb/download.html) 2.10.0-rc.1

## Setup

Install dependencies:

```sh
make install
```
## Usage

Generate execution trace for a sample arguments file:

```sh
make execute
```

Run Stwo prover:

```sh
make prove
```

The command will generate a proof and verify it locally.

## Testing

Run the test suite:

```sh
scarb test
```

### Generating Nostr events

In order to generate Nostr events, use the `gen_events.py` script.

```sh
python scripts/gen_events.py [number_of_events]
```

This will generate `number_of_events` Nostr events and print them to the stdout.

The following command will generate 10 events and save them to `tests/data/sample_events.json`:

```sh
make events
```

### Generating Cairo program arguments

In order to run the Cairo program either in "dev" or in "prove" mode, you need to generate arguments for the program.  
Use the `gen_args.py` script to generate arguments for the program.

```sh
python scripts/gen_args.py --file tests/data/sample_events.json --target cairo-run
```

The following command will generate arguments for the program given the events file and print them to the stdout.  
Note that the `cairo-run` target is used for the "dev" mode, while the `execute` target is used for the "prove" mode.

The following command will generate arguments for the program given the events file and save them to `tests/data/sample_args.json` and `tests/data/sample_exec_args.json` respectively:

```sh
make args
```
