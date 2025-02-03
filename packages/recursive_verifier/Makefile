build:
	scarb --profile proving build --target-kinds executable

execute:
	rm -rf target/execute \
		&& scarb --profile proving execute \
		--no-build \
		--arguments-file tests/data/proof_rec.json \
		--print-program-output

burn:
	scarb burn --arguments-file tests/data/proof_rec.json --output-file target/graph.svg --open-in-browser
