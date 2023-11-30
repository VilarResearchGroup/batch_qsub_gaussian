#!/bin/bash

NORM=norm_term
ERR=err_term
mkdir $NORM $ERR

grep -rl "Normal termination" --include="*.log" --include="*.LOG" |  xargs -I{} cp "{}" ${NORM}
grep -rl "Error termination" --include="*.log" --include="*.LOG" |  xargs -I{} cp "{}" ${ERR}

NORM_COUNT=$(find ${NORM} -type f -name '*.log' | wc -l)
ERR_COUNT=$(find ${ERR} -type f -name '*.log' | wc -l)

echo Exported $NORM_COUNT log files with Normal Termination
echo Exported $ERR_COUNT log files with Error Termination
