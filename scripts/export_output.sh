#!/bin/bash

# Make new output directory
mkdir output

# Copy all files in all directories with the extension .log .fchk .chk into the output directory.
cp ./*/*.log ./output/
cp ./*/*.chk ./output/
cp ./*/*.fchk ./output/

# Count the number of files in the output directory.
FILE_COUNT=$(ls output -1 --file-type | grep -v '/$' | wc -l)

echo Exported $FILE_COUNT log files.
