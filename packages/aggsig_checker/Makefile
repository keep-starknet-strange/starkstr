NUM_EVENTS ?= 10
OUTPUT_DIR ?= tests/data
SCARB = ~/.local/share/scarb-install/nightly/bin/scarb

install-stwo:
	RUSTFLAGS="-C target-cpu=native -C opt-level=3" \
		cargo install \
		--git https://github.com/starkware-libs/stwo-cairo \
		--rev f23b836909fdee27760bf5d7e7bf12110b7d562b \
		adapted_stwo

install-cairo1-run:
	cargo install \
		--git https://github.com/lambdaclass/cairo-vm \
		--rev 9c44e1cef56c6ea557d6441e27ad3c756bbbe8a9 \
		--features mod_builtin \
		cairo1-run

install-requirements:
	pip install -r scripts/requirements.txt

install:
	$(MAKE) install-stwo
	$(MAKE) install-requirements

build:
	$(SCARB) --profile proving build --target-kinds executable

build-sierra:
	$(SCARB) --profile proving build --target-kinds lib

events:
	python scripts/gen_events.py $(NUM_EVENTS) > $(OUTPUT_DIR)/events.json

args:
	python scripts/gen_args.py --file $(OUTPUT_DIR)/events.json --target execute > $(OUTPUT_DIR)/args.json
	python scripts/gen_args.py --file $(OUTPUT_DIR)/events.json --target cairo-run > $(OUTPUT_DIR)/args_test.json

execute:
	rm -rf target/execute \
		&& $(SCARB) --profile proving execute \
		--no-build \
		--target standalone \
		--arguments-file $(OUTPUT_DIR)/args.json \
		--print-program-output

cairo-execute:
	rm -rf target/execute \
		&& mkdir -p target/execute/aggsig_checker/execution1 \
		&& cairo-execute \
		--layout all_cairo_stwo \
		--args-file $(OUTPUT_DIR)/args.json \
		--standalone \
		--disable-trace-padding true \
		--prebuilt \
		--trace-file target/execute/aggsig_checker/execution1/trace.bin \
		--memory-file target/execute/aggsig_checker/execution1/memory.bin \
		--air-public-input target/execute/aggsig_checker/execution1/air_public_input.json \
		--air-private-input target/execute/aggsig_checker/execution1/air_private_input.json \
		target/proving/aggsig_checker.executable.json

cairo1-run:
	cairo1-run target/proving/aggsig_checker.sierra.json \
		--layout all_cairo \
		--args_file $(OUTPUT_DIR)/args_cairo1_run.txt \
		--proof_mode \
		--air_public_input target/execute/aggsig_checker/execution1/air_public_input.json \
		--air_private_input target/execute/aggsig_checker/execution1/air_private_input.json \
		--trace_file target/execute/aggsig_checker/execution1/trace.bin \
		--memory_file target/execute/aggsig_checker/execution1/memory.bin

prove:
	adapted_stwo \
		--priv_json target/execute/aggsig_checker/execution1/air_private_input.json \
		--pub_json target/execute/aggsig_checker/execution1/air_public_input.json \
		--params_json prover_params.json \
		--proof_path target/proof.json \
		--verify

prove-rec:
	adapted_stwo \
		--priv_json target/execute/aggsig_checker/execution1/air_private_input.json \
		--pub_json target/execute/aggsig_checker/execution1/air_public_input.json \
		--params_json prover_params_rec.json \
		--proof_path target/proof_rec.json \
		--proof-format cairo-serde \
		--verify

e2e:
	$(MAKE) events
	$(MAKE) args
	$(MAKE) build
	$(MAKE) execute
	$(MAKE) prove

burn:
	scarb burn --arguments-file tests/data/args.json --output-file target/graph.svg --open-in-browser
