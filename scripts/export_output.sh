#!/bin/bash

# Define directories
NORM_LOG_DIR="norm_term-log"
NORM_CHK_DIR="norm_term-chk"
NORM_FCHK_DIR="norm_term-fchk"
ERR_LOG_DIR="err_term-log"

# Create directories
mkdir -p "$NORM_LOG_DIR" "$NORM_CHK_DIR" "$NORM_FCHK_DIR" "$ERR_LOG_DIR"

# Find and copy normal termination logs and corresponding chk files
grep -ril --include=\*.log --include=\*.LOG "Normal termination" . | while read -r log_file; do
  cp "$log_file" "$NORM_LOG_DIR"

  # Get base name without extension and directory
  base_name="$(basename "$log_file" .log)"
  chk_file="${log_file%.log}.chk"
  alt_chk_file="${log_file%.LOG}.chk"

  # Copy .chk file if it exists
  if [[ -f "$chk_file" ]]; then
    cp "$chk_file" "$NORM_CHK_DIR"
  elif [[ -f "$alt_chk_file" ]]; then
    cp "$alt_chk_file" "$NORM_CHK_DIR"
  fi
done

# Find and copy error termination logs
grep -ril --include=\*.log --include=\*.LOG "Error termination" . | while read -r log_file; do
  cp "$log_file" "$ERR_LOG_DIR"
done

# Count and report
NORM_LOG_COUNT=$(find "$NORM_LOG_DIR" -type f | wc -l)
NORM_CHK_COUNT=$(find "$NORM_CHK_DIR" -type f | wc -l)
ERR_LOG_COUNT=$(find "$ERR_LOG_DIR" -type f | wc -l)

echo "Exported $NORM_LOG_COUNT Normal Termination log files to $NORM_LOG_DIR"
echo "Exported $NORM_CHK_COUNT corresponding chk files to $NORM_CHK_DIR"
echo "Exported $ERR_LOG_COUNT Error Termination log files to $ERR_LOG_DIR"