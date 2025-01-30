NUM_EVENTS ?= 10
OUTPUT_DIR ?= tests/data

install-stwo:
	RUSTFLAGS="-C target-cpu=native -C opt-level=3" \
		cargo install \
		--git https://github.com/m-kus/stwo-cairo \
		--rev df1d4984c2d10ba06aca54a38892bb20cedfd5de \
		adapted_stwo

install-requirements:
	pip install -r scripts/requirements.txt

install:
	$(MAKE) install-stwo
	$(MAKE) install-requirements

build:
	scarb --profile proving build --target-kinds executable

events:
	python scripts/gen_events.py $(NUM_EVENTS) > $(OUTPUT_DIR)/events.json

args:
	python scripts/gen_args.py --file $(OUTPUT_DIR)/events.json --target execute > $(OUTPUT_DIR)/args.json

execute:
	rm -rf target/execute \
		&& scarb --profile proving execute \
		--no-build \
		--arguments-file $(OUTPUT_DIR)/args.json \
		--print-program-output

prove:
	adapted_stwo \
		--priv_json target/execute/aggsig_checker/air_private_input.json \
		--pub_json target/execute/aggsig_checker/air_public_input.json \
		--params_json prover_params.json \
		--proof_path target/proof.json \
		--verify

e2e:
	$(MAKE) events
	$(MAKE) args
	$(MAKE) build
	$(MAKE) execute
	$(MAKE) prove

burn:
	scarb burn --arguments-file tests/data/args.json --no-build --output-file target/graph.svg --open-in-browser
