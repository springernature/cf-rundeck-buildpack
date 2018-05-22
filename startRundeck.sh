#!/bin/sh

BASE_PATH=/home/vcap/app

echo "-----> Making java available"
export PATH=$PATH:${BASE_PATH}/.java/bin

echo "-----> Replacing environment variables"
for file in ${BASE_PATH}/*
do
    if [[ -f ${file} ]]; then
        echo "       in $file"
        ./replaceEnvVariables.sh ${file}
    fi
done

echo "-----> Starting Rundeck"
export RDECK_BASE=${BASE_PATH}/rundeck

ADDITIONAL_ARGS="-Dserver.http.port=${PORT}"

ADDITIONAL_ARGS="${ADDITIONAL_ARGS} -Dloginmodule.conf.name=jaas-login.conf -Dloginmodule.name=RDpropertyfilelogin"

JAVA_CALL="${ADDITIONAL_ARGS} \
    -jar $RDECK_BASE/rundeck.jar \
    -b $RDECK_BASE \
    --skipinstall \
    --configdir '${BASE_PATH}'"

echo "       execute 'java $JAVA_CALL'"
java ${JAVA_CALL}