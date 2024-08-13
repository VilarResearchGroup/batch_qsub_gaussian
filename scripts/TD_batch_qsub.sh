#!/bin/bash

# Loop over all Gaussian input files with extension .gjf.
for F in *.gjf; do

# Save the filename without the file extension.
FNAME=${F%.*}

echo "Submitting ${FNAME}."

# Convert chk to fchk (have .chk and .gjf file from geom_opt
module load gaussian
formchk ${FNAME}_opt.chk ${FNAME}_opt.fchk

# Make new directory for current gjf.
NEW_DIR="${FNAME}_opt"
mkdir $NEW_DIR

# Move submission script subgauss.sh into each new directory and rename.
cp subgauss.sh "$NEW_DIR/$FNAME.sh"

# Move gjf and fchk into respective directory.
mv $F "$NEW_DIR/$FNAME.gjf"
mv "${FNAME}_opt.fchk" "$NEW_DIR/${FNAME}_opt.fchk"

# Move into new gjf directory.
cd $NEW_DIR

# Insert filename into relevant fields in submission script subgauss.sh.
sed -i "s/JOB_NAME/${FNAME}_opt/g" $FNAME.sh
sed -i "s/INPUT_NAME/$FNAME.gjf/g" $FNAME.sh

# Queue Gaussian calculation.
qsub $FNAME.sh

# Return back to working directory.
cd ../

done
