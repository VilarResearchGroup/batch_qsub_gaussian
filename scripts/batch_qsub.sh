#!/bin/bash

# Default values
ncpus=8
mem=100
walltime="08:00:00"

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
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Loop over all Gaussian input files with extension .gjf.
for F in *.gjf; do

  # Save the filename without the file extension.
  FNAME=${F%.*}

  echo "Submitting ${FNAME}."

  # Make new directory for current gjf.
  NEW_DIR="${FNAME}"
  mkdir $NEW_DIR

  # Move submission script subgauss.sh into each new directory and rename.
  cp subgauss.sh "$NEW_DIR/$FNAME.sh"

  # Move gjf into respective directory.
  mv $F "$NEW_DIR/$FNAME.gjf"
  # mv "$FNAME.chk" "$NEW_DIR/$FNAME.chk"

  # Move into new gjf directory.
  cd $NEW_DIR

  # Insert filename and PBS resource values into submission script.
  sed -i "s/INPUT_NAME/$FNAME/g" $FNAME.sh
  sed -i "s/REPLACE_NCPUS/${ncpus}/g" $FNAME.sh
  sed -i "s/REPLACE_MEM/${mem}gb/g" $FNAME.sh
  sed -i "s/REPLACE_WALLTIME/$walltime/g" $FNAME.sh

  # Queue Gaussian calculation.
  qsub $FNAME.sh

  # Return back to working directory.
  cd ../

done