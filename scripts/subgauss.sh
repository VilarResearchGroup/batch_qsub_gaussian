#!/bin/bash

#PBS -lselect=1:ncpus=REPLACE_NCPUS:mem=REPLACE_MEM
#PBS -lwalltime=REPLACE_WALLTIME
#PBS -j oe
#PBS -N INPUT_NAME

echo "Job $PBS_JOBID started at $(date '+%A %W %Y %X') on $(cat $PBS_NODEFILE)"

export GAUSS_SCRDIR=$TMPDIR

cd $TMPDIR
mkdir gjob
cd gjob

## Grab input file
cp $PBS_O_WORKDIR/INPUT_NAME.gjf INPUT_NAME.gjf

export chkfile=INPUT_NAME.chk

echo "This is the chkfile: $chkfile"
echo

## Only copy the chk file if it exists (restart-safe)
if [ -f "$PBS_O_WORKDIR/$chkfile" ]; then
    echo "Found existing chkfile, copying to scratch..."
    cp "$PBS_O_WORKDIR/$chkfile" "$chkfile"
else
    echo "No existing chkfile found, starting fresh."
fi

# Load Gaussian module and run
module load gaussian/g16-c01-avx2
g16 INPUT_NAME.gjf &

# While job is running - every 10s copy log and chk to work dir
while ps -p $! &>/dev/null; do
    for x in *.log; do
        cp $x $PBS_O_WORKDIR/INPUT_NAME.log_temp
    done

    if test -f "$chkfile"; then
        cp "$chkfile" "$PBS_O_WORKDIR/$chkfile"
    fi

    sleep 10
done

# Once GDV is done, format any *F.chk files
count=`ls -1 *F.chk 2>/dev/null | wc -l`
if [ $count != 0 ]; then
    for x in *F.chk; do formchk $x; done
fi

# Delete temp log if it exists
if test -f $PBS_O_WORKDIR/INPUT_NAME.log_temp; then
    rm $PBS_O_WORKDIR/INPUT_NAME.log_temp
fi

# Final rsync of output files
rsync -zarv --include '*.log' --include '*.fchk' --include '*.chk' --exclude '*' * $PBS_O_WORKDIR

# Script adapted from Luke Moore and Don Danilov's script.