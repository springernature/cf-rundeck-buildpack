#!/bin/sh

echo "-----> Making java available"
export PATH=$PATH:/home/vcap/app/.java/bin

echo "-----> Setting rundeck-config.properties"
echo "       server.http.port=${PORT}"
echo "\n ------- The following properties were automatically created by the buildpack -----\n" >> ./rundeck-config.properties
echo "server.http.port=${PORT}\n" >> ./rundeck-config.properties

# Replace all environment variables with syntax ${MY_ENV_VAR} with the value
# thanks to https://stackoverflow.com/questions/5274343/replacing-environment-variables-in-a-properties-file
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' ./rundeck-config.properties > ./rundeck-config_replaced.properties
mv ./rundeck-config_replaced.properties ./rundeck-config.properties

echo "-----> Starting Rundeck"

java -jar /home/vcap/app/rundeck.jar