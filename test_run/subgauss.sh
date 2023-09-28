#!/bin/bash

#PBS -lselect=1:ncpus=32:mem=13gb
#PBS -lwalltime=72:00:00
#PBS -j oe
#PBS -N JOB_NAME

echo "Job $PBS_JOBID started at $(date '+%A %W %Y %X') on $(cat $PBS_NODEFILE)"

export GAUSS_SCRDIR=$TMPDIR

cd $TMPDIR
mkdir gjob
cd gjob

## Grab input file
cp $PBS_O_WORKDIR/INPUT_NAME INPUT_NAME

## Grab chk files (if needed)
if [ -z ${chkfile+x} ]
  then
  echo "No checkpoint files to get!";
else
  cp $PBS_O_WORKDIR/$chkfile $chkfile;
fi

# Un(comment) to run G16
module load gaussian/g16-c01-avx2
g16 INPUT_NAME &

# While job is running - every 10s grab the log file
while ps -p $! &>/dev/null; do
    for x in *.log; do cp $x $PBS_O_WORKDIR/INPUT_NAME.log_temp; done
    sleep 10
done

# Once GDV is dne format up any *F.chk files
count=`ls -1 *F.chk 2>/dev/null | wc -l`
if [ $count != 0 ]
then
for x in *F.chk; do formchk $x; done;
fi

# If ended up making a templog file - delete it
if test -f $PBS_O_WORKDIR/INPUT_NAME.log_temp; then
    rm $PBS_O_WORKDIR/INPUT_NAME.log_temp
fi

# Rsync across the folder
rsync -zarv --include '*.log' --include '*.fchk' --include '*.chk' --exclude '*' * $PBS_O_WORKDIR

# Script written by Luke Moore and Don Danilov.