#!/bin/bash

# Change to the package directory
cd packages/aggsig_checker || exit 1

# Create temporary directory
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# Build once
make build

# Arrays to store results
declare -a events_arr
declare -a prover_times
declare -a verifier_times
declare -a proof_sizes
declare -a total_steps

# Run benchmarks
row=0
for n in $(seq 5 5 50); do
    export NUM_EVENTS=$n
    export OUTPUT_DIR=$TMP_DIR

    make events
    make args
    make execute
    
    # Capture prove output and print to stderr before processing
    raw_output=$(make prove 2>&1)
    echo "$raw_output" >&2
    
    # Remove ANSI color codes
    prove_output=$(echo "$raw_output" | sed 's/\x1b\[[0-9;]*m//g')
    
    # Check if verification was successful
    if ! echo "$prove_output" | grep -q "Proof verified successfully"; then
        # If verification failed, store dashes and exit
        events_arr[$row]=$n
        prover_times[$row]="-"
        verifier_times[$row]="-"
        proof_sizes[$row]="-"
        total_steps[$row]="-"
        break
    fi
    
    # Extract timings using grep and sed
    prover_time=$(echo "$prove_output" | grep "run:prove_cairo: stwo_cairo_prover::cairo_air: close" | sed -E 's/.*time.busy=([0-9.]+[ms]+).*/\1/')
    verifier_time=$(echo "$prove_output" | grep "run:verify_cairo: stwo_cairo_prover::cairo_air: close" | sed -E 's/.*time.busy=([0-9.]+[ms]+).*/\1/')
    
    # Extract total steps
    steps=$(echo "$prove_output" | grep "Total steps:" | sed -E 's/.*Total steps: ([0-9]+).*/\1/')
    
    # Get proof size in MB (using bc for floating point arithmetic)
    size_bytes=$(stat -f %z "target/proof.json")
    proof_size=$(echo "scale=2; $size_bytes / 1048576" | bc)
    
    # Store results
    events_arr[$row]=$n
    prover_times[$row]=$prover_time
    verifier_times[$row]=$verifier_time
    proof_sizes[$row]="${proof_size}MB"
    total_steps[$row]=$steps
    
    ((row++))
done

# Print the complete table at the end
printf "\n\n"  # Add some space after the logs
printf "+------------+-------------+---------------+-------------+-------------+\n"
printf "| num events | prover time | verifier time | proof size  | total steps |\n"
printf "+------------+-------------+---------------+-------------+-------------+\n"

for ((i=0; i<${#events_arr[@]}; i++)); do
    printf "| %10d | %11s | %13s | %11s | %11s |\n" \
        "${events_arr[$i]}" \
        "${prover_times[$i]}" \
        "${verifier_times[$i]}" \
        "${proof_sizes[$i]}" \
        "${total_steps[$i]}"
done

printf "+------------+-------------+---------------+-------------+-------------+\n" 