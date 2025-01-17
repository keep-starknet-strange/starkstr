#!/bin/bash

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

    # Build event string
    EVENT_STR="${PK_LOW}, ${PK_HIGH}, ${RX_LOW}, ${RX_HIGH}, ${S_LOW}, ${S_HIGH}, ${M_LOW}, ${M_HIGH}"
    
    # Add to events array
    if [ -z "$EVENTS_ARRAY" ]; then
        EVENTS_ARRAY="$EVENT_STR"
    else
        EVENTS_ARRAY="$EVENTS_ARRAY, $EVENT_STR"
    fi
done

# Construct the command
CMD_PREFIX="scarb cairo-run"
CMD_ARGS="'[[${EVENTS_ARRAY}]]'"
CMD="${CMD_PREFIX} ${CMD_ARGS}"

cd packages/aggsig_checker
#echo "Running command: ${CMD}"
echo "Running Cairo program"
# Run the command
eval ${CMD}
cd ../..