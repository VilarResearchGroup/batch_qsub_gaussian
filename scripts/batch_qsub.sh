#!/bin/bash

# Default values
ncpus=8
mem=100
walltime="08:00:00"
chkfile=""

show_help() {
  echo ""
  echo "Usage: bash batch_qsub.sh [options]"
  echo ""
  echo "Options:"
  echo "  -n, --ncpus [INT]         Number of CPUs per job (default: 8)"
  echo "  -m, --mem [INT]           Memory in GB (default: 100)"
  echo "  -w, --walltime [HH:MM:SS] Walltime (default: 08:00:00)"
  echo "  -c, --chk [FILENAME]      Optional: checkpoint file to move into each job folder."
  echo "                            If omitted, moves \$FNAME.chk by default."
  echo "                            If used without argument, defaults to GJF_FILENAME.chk."
  echo "  -h, --help                Show this help message and exit"
  echo ""
  echo "Job Sizing Reference:"
  echo "  Imperial College London HPC Job Size Guide:"
  echo "  https://icl-rcs-user-guide.readthedocs.io/en/latest/hpc/queues/job-sizing-guidance/"
  echo ""
  exit 0
}

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
    -h|--help)
      show_help
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use -h or --help for usage instructions."
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