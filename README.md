# STARKstr 🌟

> Exploring STARK proofs for enhancing Nostr's privacy, scalability, and functionality.

STARKstr is a research project exploring the potential benefits of STARK proofs for the Nostr ecosystem. It serves as a collection of proof of concepts and explorations in this direction.

## 🎯 Current Focus: Delegated Aggregate Signature Verification

Our first exploration focuses on enabling relays to strip signatures from events and provide STARK proofs that those signatures were valid. This approach offers several benefits:

- **Enhanced Privacy**: Signatures are not revealed, providing deniability
- **Reduced Bandwidth**: Events can be transmitted without signatures
- **Batch Verification**: Multiple signatures can be verified in a single proof
- **Trust Minimization**: Clients can verify the proof instead of trusting the relay

This work is related to [NIP PR #1682](https://github.com/nostr-protocol/nips/pull/1682), which proposes a standard for delegated signature verification.

## 🏗️ Architecture

The project is structured into several components:

```
starkstr/
├── src/                    # Cairo code that will be used for STARK proof generation
│   ├── lib.cairo           # Main Cairo library
│   └── fmt_utils.cairo     # Utility functions
├── scripts/
│   ├── nostr-data-gen/    # TypeScript tools for generating test data
│   │   ├── src/           # Source code
│   │   └── out/           # Generated Nostr events
│   └── verify-nostr.sh    # Script to run the verification flow
└── tests/                  # Test suite
```

### Components

1. **Nostr Event Generator** (TypeScript)

   - Generates sample Nostr events
   - Signs events using Schnorr signatures
   - Outputs events in JSON format

2. **starkstr cairo crate** (Cairo)
   - Verifies Schnorr signatures
   - Will be used to generate proofs of valid signatures
   - Supports batch verification

## 🚀 Getting Started

### Prerequisites

- [Scarb](https://docs.swmansion.com/scarb/download.html) - Cairo package manager
- [Node.js](https://nodejs.org/) (v16 or later)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/AbdelStark/starkstr.git
   cd starkstr
   ```

2. Install TypeScript dependencies:

   ```bash
   cd scripts/nostr-data-gen
   npm install
   cd ../..
   ```

3. Build the Cairo code:
   ```bash
   scarb build
   ```

### Usage

1. Generate a sample Nostr event:

   ```bash
   cd scripts/nostr-data-gen
   npm run start
   cd ../..
   ```

   This will create a signed event in `scripts/nostr-data-gen/out/sample-signed-event.json`

2. Verify the signature using Cairo:
   ```bash
   ./scripts/verify-nostr.sh
   ```

## 🧪 Testing

Run the test suite:

```bash
scarb test
```

## 📊 Benchmarks

> Coming soon: We will be adding comprehensive benchmarks to evaluate:
>
> - Proof generation time
> - Verification time
> - Cloud costs
> - Memory usage
> - Network overhead

## 🛣️ Roadmap

1. **Phase 1: Proof of Concept** (Current)

   - ✅ Basic Schnorr signature verification in Cairo
   - ✅ Test data generation
   - 🔄 Batch verification
   - 🔄 STARK proof generation

2. **Phase 2: Benchmarking**

   - Cloud cost analysis
   - Latency measurements
   - Scalability testing

3. **Phase 3: Integration**
   - Relay implementation
   - Client libraries
   - Documentation

## 🤝 Contributing

We welcome contributions! Please check our [Contributing Guidelines](CONTRIBUTING.md) for details on how to submit pull requests, report issues, and contribute to the project.

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Nostr Protocol](https://github.com/nostr-protocol/nostr)
- [StarkWare](https://starkware.co/) for Cairo and STARK technology
- [Alexandria](https://github.com/keep-starknet-strange/alexandria) for Cairo utilities

---

<p align="center">
  Made with ⚡️ by the Nostr community
</p>
