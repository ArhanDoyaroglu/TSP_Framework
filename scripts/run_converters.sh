#!/bin/bash

# Define converter script paths
geo_converter="/home/users/arhandoyaroglu/suOPT/benchmark/geo2euc_converter.py"
euc_converter="/home/users/arhandoyaroglu/suOPT/benchmark/euc2fullmatrix_converter.py"

# Prompt user for conversion choice
echo "Select conversion option:"
echo "1. GEO → EUC_2D"
echo "2. EUC_2D → FULL_MATRIX"
echo "3. Run both"
read -p "Enter choice (1/2/3): " choice

case $choice in
  1)
    echo "Running GEO to EUC_2D converter..."
    python3 "$geo_converter"
    echo "Finished GEO to EUC_2D conversion"
    ;;
  2)
    echo "Running EUC_2D to FULL_MATRIX converter..."
    python3 "$euc_converter"
    echo "Finished EUC_2D to FULL_MATRIX conversion"
    ;;
  3)
    echo "Running GEO to EUC_2D converter..."
    python3 "$geo_converter"
    echo "Finished GEO to EUC_2D conversion"

    echo "Running EUC_2D to FULL_MATRIX converter..."
    python3 "$euc_converter"
    echo "Finished EUC_2D to FULL_MATRIX conversion"
    ;;
  *)
    echo "Invalid choice. Exiting."
    exit 1
    ;;
esac