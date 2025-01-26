#!/bin/bash

# Function to convert decimal to hexadecimal using bc
to_hex() {
    echo "\"0x$(echo "obase=16; $1" | bc)\""
}

# Generate Nostr event data
cd apps/aggsig_checker_cli
echo "Generating Nostr event data"
npm run start
cd ../..

# Read the JSON file and extract Cairo parameters
JSON_FILE="apps/aggsig_checker_cli/out/nostr_events_batch.json"

# Function to extract values from JSON using jq
extract_values() {
    local index=$1
    local param=$2
    jq -r ".[$index].cairoParams.$param.low, .[$index].cairoParams.$param.high" "$JSON_FILE"
}

# Build the command arguments
EVENTS_ARRAY=""
NUM_EVENTS=$(jq length "$JSON_FILE")

for ((i=0; i<NUM_EVENTS; i++)); do
    # Extract values for current event
    PK_LOW=$(extract_values $i "pk" | head -n1)
    PK_HIGH=$(extract_values $i "pk" | tail -n1)
    RX_LOW=$(extract_values $i "rx" | head -n1)
    RX_HIGH=$(extract_values $i "rx" | tail -n1)
    S_LOW=$(extract_values $i "s" | head -n1)
    S_HIGH=$(extract_values $i "s" | tail -n1)
    M_LOW=$(extract_values $i "m" | head -n1)
    M_HIGH=$(extract_values $i "m" | tail -n1)

    # Convert each value to hexadecimal string using bc
    PK_LOW=$(to_hex $PK_LOW)
    PK_HIGH=$(to_hex $PK_HIGH)
    RX_LOW=$(to_hex $RX_LOW)
    RX_HIGH=$(to_hex $RX_HIGH)
    S_LOW=$(to_hex $S_LOW)
    S_HIGH=$(to_hex $S_HIGH)
    M_LOW=$(to_hex $M_LOW)
    M_HIGH=$(to_hex $M_HIGH)

    # Build event string
    EVENT_STR="${PK_LOW}, ${PK_HIGH}, ${RX_LOW}, ${RX_HIGH}, ${S_LOW}, ${S_HIGH}, ${M_LOW}, ${M_HIGH}"
    
    # Add to events array
    if [ -z "$EVENTS_ARRAY" ]; then
        EVENTS_ARRAY="$EVENT_STR"
    else
        EVENTS_ARRAY="$EVENTS_ARRAY, $EVENT_STR"
    fi
done

ARRAY_LEN=$((NUM_EVENTS*8+1))
ARRAY_LEN_HEX=$(to_hex $ARRAY_LEN)
NUM_EVENTS_HEX=$(to_hex $NUM_EVENTS)
EXECUTE_ARGS="[${ARRAY_LEN_HEX}, ${NUM_EVENTS_HEX}, $EVENTS_ARRAY]"

cd packages/aggsig_checker

echo "Cleaning up previous execution..."
rm -rf target/execute || true
mkdir -p target/execute

echo "Writing arguments to file..."
echo "$EXECUTE_ARGS" > target/execute/args.json

echo "Producing execution trace..."
scarb --profile proving execute --print-program-output --arguments-file target/execute/args.json

echo "Generating proof and verifying it..."
make prove
cd ../..
