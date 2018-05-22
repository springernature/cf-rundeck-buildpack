#!/usr/bin/env bash

FILENAME=$1
TEMP_FILENAME=${FILENAME}_replaced

# Replace all environment variables with syntax ${MY_ENV_VAR} with the value
# thanks to https://stackoverflow.com/questions/5274343/replacing-environment-variables-in-a-properties-file
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' ${FILENAME} > ${TEMP_FILENAME}
mv ${TEMP_FILENAME} ${FILENAME}