#!/bin/bash

# Default values
ncpus=8
mem=100
walltime="08:00:00"
chkfile=""

# Parse CLI options
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--ncpus)
      ncpus="$2"
      shift 2
      ;;
    -m|--mem)
      mem="$2"
      shift 2
      ;;
    -w|--walltime)
      walltime="$2"
      shift 2
      ;;
    -c|--chk)
      # If next arg is another option or empty, fallback to default chk
      if [[ -z "$2" || "$2" == -* ]]; then
        chkfile="__default__"
        shift 1
      else
        chkfile="$2"
        shift 2
      fi
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Loop over all Gaussian input files with extension .gjf.
for F in *.gjf; do
  FNAME=${F%.*}
  echo "Submitting ${FNAME}."

  NEW_DIR="${FNAME}"
  mkdir "$NEW_DIR"

  cp subgauss.sh "$NEW_DIR/$FNAME.sh"
  mv "$F" "$NEW_DIR/$FNAME.gjf"

  # Decide which .chk file to move
  if [[ "$chkfile" == "__default__" || -z "$chkfile" ]]; then
    mv "$FNAME.chk" "$NEW_DIR/$FNAME.chk"
  else
    mv "$chkfile" "$NEW_DIR/$chkfile"
  fi

  cd "$NEW_DIR"

  # Replace placeholders in PBS script
  sed -i "s/INPUT_NAME/$FNAME/g" "$FNAME.sh"
  sed -i "s/REPLACE_NCPUS/${ncpus}/g" "$FNAME.sh"
  sed -i "s/REPLACE_MEM/${mem}gb/g" "$FNAME.sh"
  sed -i "s/REPLACE_WALLTIME/$walltime/g" "$FNAME.sh"

  qsub "$FNAME.sh"
  cd ../
done