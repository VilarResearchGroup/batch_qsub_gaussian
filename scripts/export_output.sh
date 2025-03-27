#!/bin/bash

# Define directories
NORM_DIR="norm_term"
ERR_DIR="err_term"

# Create directories if they don't exist
mkdir -p "$NORM_DIR" "$ERR_DIR"

# Define log file pattern
LOG_PATTERN="*.log *.LOG"

# Copy files with "Normal termination"
grep -ril --include=\*.log --include=\*.LOG "Normal termination" . | while read -r file; do
  cp "$file" "$NORM_DIR"
done

# Copy files with "Error termination"
grep -ril --include=\*.log --include=\*.LOG "Error termination" . | while read -r file; do
  cp "$file" "$ERR_DIR"
done

# Count files
NORM_COUNT=$(find "$NORM_DIR" -type f \( -iname "*.log" -o -iname "*.LOG" \) | wc -l)
ERR_COUNT=$(find "$ERR_DIR" -type f \( -iname "*.log" -o -iname "*.LOG" \) | wc -l)

# Output results
echo "Exported $NORM_COUNT log files with Normal Termination"
echo "Exported $ERR_COUNT log files with Error Termination"