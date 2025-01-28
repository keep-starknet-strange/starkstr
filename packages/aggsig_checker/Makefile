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


install-requirements:
	pip install -r scripts/requirements.txt

install:
	$(MAKE) install-scarb
	$(MAKE) install-stwo
	$(MAKE) install-requirements

sample:
	python scripts/gen_events.py 1 > target/events.json
	python scripts/gen_args.py --file target/events.json --target cairo-run > tests/data/sample.json
	python scripts/gen_args.py --file target/events.json --target execute > tests/data/sample_exec.json

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
