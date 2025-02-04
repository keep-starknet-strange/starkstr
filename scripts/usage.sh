#!/bin/bash

# Change to the package directory
cd packages/aggsig_checker || exit 1

# Arrays to store results
declare -a events_arr
declare -a range_check_arr
declare -a bitwise_arr
declare -a range_check96_arr
declare -a mul_mod_arr
declare -a add_mod_arr
declare -a poseidon_arr
declare -a total_steps_arr

# Run analysis
row=0
for n in $(seq 5 5 50); do
    export NUM_EVENTS=$n

    make events
    make args
    
    # Capture execute output
    raw_output=$(make execute 2>&1)
    echo "$raw_output" >&2
    
    # Extract total steps
    total_steps=$(echo "$raw_output" | grep -o "steps: [0-9]*" | awk '{print $2}')
    
    # Extract builtin usage using grep and sed
    builtins_line=$(echo "$raw_output" | grep "builtins:")
    
    range_check=$(echo "$builtins_line" | grep -o '"range_check_builtin": [0-9]*' | awk '{print $2}')
    bitwise=$(echo "$builtins_line" | grep -o '"bitwise_builtin": [0-9]*' | awk '{print $2}')
    range_check96=$(echo "$builtins_line" | grep -o '"range_check96_builtin": [0-9]*' | awk '{print $2}')
    mul_mod=$(echo "$builtins_line" | grep -o '"mul_mod_builtin": [0-9]*' | awk '{print $2}')
    add_mod=$(echo "$builtins_line" | grep -o '"add_mod_builtin": [0-9]*' | awk '{print $2}')
    poseidon=$(echo "$builtins_line" | grep -o '"poseidon_builtin": [0-9]*' | awk '{print $2}')
    
    # Store results
    events_arr[$row]=$n
    range_check_arr[$row]=$range_check
    bitwise_arr[$row]=$bitwise
    range_check96_arr[$row]=$range_check96
    mul_mod_arr[$row]=$mul_mod
    add_mod_arr[$row]=$add_mod
    poseidon_arr[$row]=$poseidon
    total_steps_arr[$row]=$total_steps
    
    ((row++))
done

# Print the table
printf "\n\n"  # Add some space after the logs
printf "+------------+----------------+----------------+--------------------+----------------+---------------+-----------------+----------------+\n"
printf "| num events | range_check    | bitwise        | range_check96      | mul_mod        | add_mod       | poseidon        | total steps    |\n"
printf "+------------+----------------+----------------+--------------------+----------------+---------------+-----------------+----------------+\n"

for ((i=0; i<${#events_arr[@]}; i++)); do
    printf "| %10d | %14d | %14d | %18d | %14d | %13d | %15d | %14d |\n" \
        "${events_arr[$i]}" \
        "${range_check_arr[$i]}" \
        "${bitwise_arr[$i]}" \
        "${range_check96_arr[$i]}" \
        "${mul_mod_arr[$i]}" \
        "${add_mod_arr[$i]}" \
        "${poseidon_arr[$i]}" \
        "${total_steps_arr[$i]}"
done

printf "+------------+----------------+----------------+--------------------+----------------+---------------+-----------------+----------------+\n" 