NUM_EVENTS ?= 5
OUTPUT_DIR ?= tests/data
TARGET_DIR ?= ../../target

install-stwo:
	RUSTFLAGS="-C target-cpu=native -C opt-level=3" \
		cargo install \
		--git https://github.com/m-kus/stwo-cairo \
		--rev b32175604169e6fc0a7a3d35cf50d7e37865be5a \
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
	python scripts/gen_args.py --file $(OUTPUT_DIR)/events.json --target cairo-run > $(OUTPUT_DIR)/args_test.json

execute:
	rm -rf $(TARGET_DIR)/execute \
		&& scarb --profile proving execute \
		--no-build \
		--arguments-file $(OUTPUT_DIR)/args.json \
		--print-program-output \
		--print-resource-usage

run:
	scarb cairo-run --no-build --arguments-file $(OUTPUT_DIR)/args_test.json --print-resource-usage

prove:
	adapted_stwo \
		--priv_json $(TARGET_DIR)/execute/aggsig_checker/execution1/air_private_input.json \
		--pub_json $(TARGET_DIR)/execute/aggsig_checker/execution1/air_public_input.json \
		--proof_path $(TARGET_DIR)/proof.json \
		--params_json prover_params.json \
		--verify

burn:
	scarb burn --arguments-file tests/data/args.json --output-file target/graph.svg --open-in-browser

test:
	scarb test
	scarb build --target-kinds lib
	$(MAKE) run
