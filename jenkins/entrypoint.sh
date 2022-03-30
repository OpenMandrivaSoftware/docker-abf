#!/bin/sh
set -e

echo "fetch agent.jar"
pushd /
wget http://144.21.54.230:8080/jnlpJars/agent.jar
popd
java -jar agent.jar -jnlpUrl ${JENKINS} -secret ${SECRET} -workDir "/"
