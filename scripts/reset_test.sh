#!/bin/bash

# Copy all files in all directories with the extension .gjf into the working directory.
mv ./*/*.gjf ./

# Remove all job scripts.
rm ./*/*.sh

# Remove all directories.
rmdir ./*/

echo Test reset.