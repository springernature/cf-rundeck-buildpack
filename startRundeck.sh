#!/bin/sh

BASE_PATH=/home/vcap/app/

echo "-----> Making java available"
export PATH=$PATH:${BASE_PATH}.java/bin

echo "-----> Setting rundeck-config.properties"
# Replace all environment variables with syntax ${MY_ENV_VAR} with the value
# thanks to https://stackoverflow.com/questions/5274343/replacing-environment-variables-in-a-properties-file
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' ./rundeck-config.properties > ./rundeck-config_replaced.properties
mv ./rundeck-config_replaced.properties ./rundeck-config.properties


echo "-----> Starting Rundeck"
export RDECK_BASE=${BASE_PATH}

ADDITIONAL_ARGS="-Dserver.http.port=${PORT}"

if [ -f ${BASE_PATH}jaas-login.conf ]; then
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' ./jaas-login.conf > ./jaas-login_replaced.conf
    mv ./jaas-login_replaced.conf ./jaas-login.conf
    ADDITIONAL_ARGS="${ADDITIONAL_ARGS} -Dloginmodule.conf.name=jaas-login.conf -Dloginmodule.name=login"
fi


ADDITIONAL_ARGS="${ADDITIONAL_ARGS} -Dloginmodule.conf.name=jaas-loginmodule.conf -Dloginmodule.name=RDpropertyfilelogin"

JAVA_CALL="${ADDITIONAL_ARGS} \
    -jar /home/vcap/app/rundeck.jar \
    -b ${BASE_PATH} \
    --skipinstall"

echo "       execute 'java $JAVA_CALL'"
java ${JAVA_CALL}