#!/bin/sh

set -e

BASE_PATH=/home/vcap/app
export RDECK_BASE=${BASE_PATH}/rundeck


replaceEnvVariables () {
    FILENAME=$1
    TEMP_FILENAME=${FILENAME}_replaced

    # Replace all environment variables with syntax ${MY_ENV_VAR} with the value
    # thanks to https://stackoverflow.com/questions/5274343/replacing-environment-variables-in-a-properties-file
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' ${FILENAME} > ${TEMP_FILENAME}
    mv ${TEMP_FILENAME} ${FILENAME}
}

echo "-----> Making java available"
export PATH=$PATH:${BASE_PATH}/.java/bin

echo "-----> Replacing environment variables and moving property files"
cd ${BASE_PATH}
for FILE in ./*
do
    if [ -f "${FILE}" ]; then
        echo "       replace envs in $FILE"
        replaceEnvVariables ${FILE}
        CONFIG_PATH=${BASE_PATH}/config/${FILE}
        echo "       move $FILE to $CONFIG_PATH"
        mv ${FILE} ${CONFIG_PATH}
    fi
done

echo "-----> Starting Rundeck"

ADDITIONAL_ARGS="-Dserver.http.port=${PORT}"

ADDITIONAL_ARGS="${ADDITIONAL_ARGS} -Dloginmodule.conf.name=jaas-login.conf -Dloginmodule.name=RDpropertyfilelogin"

JAVA_CALL="${ADDITIONAL_ARGS} \
    -jar $RDECK_BASE/rundeck.jar \
    -b $RDECK_BASE \
    --skipinstall \
    -c "${BASE_PATH}/config" -d"

echo "       execute 'java $JAVA_CALL'"
java ${JAVA_CALL}