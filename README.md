<div align="center">

<a href="https://github.com/keep-starknet-strange/starkstr/actions/workflows/e2e.yml"><img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/keep-starknet-strange/starkstr/e2e.yml?style=for-the-badge" height=30></a>
<a href="https://nostr.org/"> <img alt="Nostr" src="https://img.shields.io/badge/Nostr-000?style=for-the-badge" height=30></a>
<a href="https://bitcoin.org/"> <img alt="Bitcoin" src="https://img.shields.io/badge/Bitcoin-000?style=for-the-badge&logo=bitcoin&logoColor=white" height=30></a>
<a href="https://eprint.iacr.org/2018/046.pdf"> <img alt="Starks" src="https://img.shields.io/badge/STARKs-000?style=for-the-badge" height=30></a>

</div>

# STARKstr 🌟

> Exploring STARK proofs for enhancing Nostr's privacy, scalability, and functionality.

STARKstr is a research project exploring the potential benefits of STARK proofs for the Nostr ecosystem. It serves as a collection of proof of concepts and explorations in this direction.

## 🎯 Current Focus: Delegated Aggregate Signature Verification

Our first exploration focuses on enabling relays to strip signatures from events and provide STARK proofs that those signatures were valid. This approach offers several benefits:

- **Reduced Bandwidth**: Events can be transmitted and archived without signatures
- **Batch Verification**: Authenticity of multiple events can be verified with a single proof
- **Trust Minimization**: Clients can verify one proof instead of trusting the relay or validating a lot of signatures

This work is related to [NIP PR #1682](https://github.com/nostr-protocol/nips/pull/1682), which proposes a standard for delegated signature verification.

## 🔄 Architecture & Proving Pipeline

STARKstr implements a complete proving pipeline for Nostr event signature verification. The system is designed to be modular and extensible, leveraging the power of STARKs to provide cryptographic guarantees.

### System Architecture

```mermaid
graph TB
    subgraph "Event Generation"
        A[Nostr NDK] --> B[Event Signer]
        B --> C[JSON Output]
    end

    subgraph "Cairo VM execution"
        C --> D[CLI Parser]
        D --> E[Cairo Program]
        E --> F[Execution Trace]
    end

    subgraph "STARK Proof Generation"
        F --> G[STWO Prover]
        G --> H[STARK Proof]
    end

    subgraph "Proof Verification"
        H --> I[STWO Verifier]
        I --> J[Verification Result]
    end

    style A fill:#f9f,stroke:#333,stroke-width:2px
    style E fill:#bbf,stroke:#333,stroke-width:2px
    style G fill:#bfb,stroke:#333,stroke-width:2px
    style I fill:#fbb,stroke:#333,stroke-width:2px
```

### Proving Pipeline Flow

```mermaid
sequenceDiagram
    participant Client
    participant NDK as Nostr NDK
    participant Cairo as Cairo Program
    participant STWO as STWO Prover
    participant Verifier as STWO Verifier

    Client->>NDK: Generate Events
    NDK->>NDK: Sign Events
    NDK->>Cairo: Batch Events
    Cairo->>Cairo: Verify Signatures
    Cairo->>STWO: Execution Trace
    STWO->>STWO: Generate Proof
    STWO->>Verifier: STARK Proof
    Verifier->>Client: Verification Result
```

### Components

1. **Nostr Event Generation**

   - Uses [Nostr SDK](https://github.com/jeffthibault/python-nostr) for event creation
   - Generates and signs events with Schnorr signatures
   - Outputs events in JSON format
   - Extends and encodes event data into Cairo program arguments

2. **Batch Signature Verification**

   - Implements verification of multiple Schnorr signatures in Cairo
   - Uses [Cairo VM](https://github.com/lambdaclass/cairo-vm) for execution
   - Generates execution trace for proving

3. **STARK Proof Generation**

   - Uses [STWO Prover](https://github.com/starkware-libs/stwo) for proof generation
   - Leverages [STWO Cairo AIR](https://github.com/starkware-libs/stwo-cairo/) for Cairo program proving
   - Produces a STARK proof of the integrity of the computation (in this case, the verification of the signatures)

4. **Proof Verification**
   - STWO verifier for proof validation
   - Can be run in browsers, Nostr clients, or any environment
   - Provides cryptographic guarantees of signature validity of a batch of Nostr events

## 🚀 Getting Started

Check out [aggsig_checker](packages/aggsig_checker/README.md) docs for the step-by-step usage guide.

## 📊 Benchmarks

> Coming soon: We will be adding comprehensive benchmarks to evaluate:
>
> - Proof generation time
> - Verification time
> - Memory usage
> - Network overhead
> - Cloud costs

## 🛣️ Roadmap

1. **Phase 1: Proof of Concept**

   - ✅ Basic Schnorr signature verification in Cairo
   - ✅ Test data generation
   - ✅ Batch verification
   - ✅ STARK proof generation

2. **Phase 2: Benchmarking** (Current)

   - 🔄 Proof generation time depending on the number of events
   - Proof verification time vs total time of signature verification
   - Proof size vs total size of signatures

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
  Made with ❤️ by the Nostr community
</p>
