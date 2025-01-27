install-scarb:
	cargo install \
		--git https://github.com/m-kus/scarb \
		--rev 2b2e7c1ab558f022ef69ef0e1d9ccaac6cebb8fc \
		scarb scarb-execute scarb-cairo-test scarb-cairo-run

install-stwo:
	RUSTFLAGS="-C target-cpu=native -C opt-level=3" \
		cargo install \
		--git https://github.com/starkware-libs/stwo-cairo \
		adapted_stwo

install:
	$(MAKE) install-scarb
	$(MAKE) install-stwo

execute:
	rm -rf target/execute \
		&& scarb --profile proving execute --arguments-file tests/data/sample_exec.json --print-program-output

run:
	scarb cairo-run --arguments-file tests/data/sample.json --print-resource-usage

prove:
	adapted_stwo \
		--priv_json target/execute/aggsig_checker/air_private_input.json \
		--pub_json target/execute/aggsig_checker/air_public_input.json \
		--proof_path target/proof.json \
		--verify
