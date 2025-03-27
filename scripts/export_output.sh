#!/bin/bash

# Define directories
NORM_LOG_DIR="norm_term-log"
NORM_CHK_DIR="norm_term-chk"
NORM_FCHK_DIR="norm_term-fchk"
ERR_LOG_DIR="err_term-log"

# Create directories
mkdir -p "$NORM_LOG_DIR" "$NORM_CHK_DIR" "$NORM_FCHK_DIR" "$ERR_LOG_DIR"

# Handle Normal termination files
grep -ril --include=\*.log --include=\*.LOG "Normal termination" . | while read -r log_file; do
  cp "$log_file" "$NORM_LOG_DIR"
  
  # Strip extension for related file lookup
  base="${log_file%.*}"

  # Copy corresponding .chk if exists
  if [[ -f "${base}.chk" ]]; then
    cp "${base}.chk" "$NORM_CHK_DIR"
  fi

  # Copy corresponding .fchk if exists
  if [[ -f "${base}.fchk" ]]; then
    cp "${base}.fchk" "$NORM_FCHK_DIR"
  fi
done

# Handle Error termination log files
grep -ril --include=\*.log --include=\*.LOG "Error termination" . | while read -r log_file; do
  cp "$log_file" "$ERR_LOG_DIR"
done

# Summary
NORM_LOG_COUNT=$(find "$NORM_LOG_DIR" -type f | wc -l)
NORM_CHK_COUNT=$(find "$NORM_CHK_DIR" -type f | wc -l)
NORM_FCHK_COUNT=$(find "$NORM_FCHK_DIR" -type f | wc -l)
ERR_LOG_COUNT=$(find "$ERR_LOG_DIR" -type f | wc -l)

echo "Exported $NORM_LOG_COUNT Normal Termination log files to $NORM_LOG_DIR"
echo "Exported $NORM_CHK_COUNT corresponding chk files to $NORM_CHK_DIR"
echo "Exported $NORM_FCHK_COUNT corresponding fchk files to $NORM_FCHK_DIR"
echo "Exported $ERR_LOG_COUNT Error Termination log files to $ERR_LOG_DIR"