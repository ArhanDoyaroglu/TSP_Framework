#!/bin/bash

# Define directories (use absolute paths)
benchmark_dir="/home/users/arhandoyaroglu/suOPT/benchmark"
output_dir="/home/users/arhandoyaroglu/suOPT/outputs/concorde"
concorde_executable="/home/users/arhandoyaroglu/suOPT/co031219/concorde/TSP/concorde"
scripts_dir="/home/users/arhandoyaroglu/suOPT/scripts"
target_base="/home/users/arhandoyaroglu/suOPT/tours"
target_concorde="$target_base/concorde_tours"

# Input directories (ONLY these are used now)
input_dirs=(
    "$benchmark_dir/opt_known_euc"
    "$benchmark_dir/opt_known_noteuc"
    "$benchmark_dir/opt_unknown_euc"
)

# Ensure output and target directories exist
mkdir -p "$output_dir"
mkdir -p "$target_concorde"

# Process each TSP file in the specified input directories
for dir in "${input_dirs[@]}"; do
    find "$dir" -type f -name "*.tsp" -exec du -b {} + | sort -n | cut -f2- | while read file; do
        output_file="${output_dir}/${file#${benchmark_dir}/}"
        output_file="${output_file%.tsp}.sol"

        # Skip if solution exists and is non-empty
        if [[ -s "$output_file" ]]; then
            echo "Skipping: $file (solution already exists and is non-empty)"
            continue
        fi

        # Create necessary directories
        mkdir -p "$(dirname "$output_file")"

        # Solve with Concorde
        echo "Solving: $file"
        "$concorde_executable" "$file" > "$output_file"

        # Verify if output is empty; retry if needed
        if [[ ! -s "$output_file" ]]; then
            echo "Warning: $output_file is empty, retrying..."
            rm "$output_file"
            "$concorde_executable" "$file" > "$output_file"
        fi

        # Move any .sol file generated in scripts directory immediately after solving
        for sol_file in "$scripts_dir"/*.sol; do
            if [[ -f "$sol_file" ]]; then
                mv "$sol_file" "$target_concorde/"
                echo "Moved $(basename "$sol_file") to $target_concorde"
            fi
        done

        # Delete temporary files created by Concorde
        echo "Cleaning up intermediate files in $scripts_dir"
        find "$scripts_dir" -type f \( -name "*.pul" -o -name "*.sav" -o -name "*.res" -o -name "*.ext" -o -name "*.dat" -o -name "*.mas" \) -delete

    done
done

echo "All Concorde tour files from scripts folder moved to: $target_concorde"
