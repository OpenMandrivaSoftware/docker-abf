#!/bin/bash
abf_env(){
echo export REDIS_HOST="$REDIS_HOST"
echo export REDIS_PORT="$REDIS_PORT"
echo export REDIS_PASSWORD="$REDIS_PASSWORD"
#echo export QUEUE="publish_worker,publish_worker_default"
echo export QUEUE="$QUEUE"
echo export COUNT="$COUNT"
echo export BUILD_TOKEN="$BUILD_TOKEN"

}

prepare_and_run() {
source /etc/profile
echo "prepare ABF publisher environment"
echo "git clone docker-publish-worker code"
cd
git clone https://github.com/OpenMandrivaSoftware/docker-publish-worker.git
pushd docker-publish-worker
export PATH="${PATH}:/usr/local/rvm/bin"
# skip $ARCH before we build hiredis gem
unset ARCH
which rvm
gem install bundler
bundle install
REDIS_HOST=$REDIS_HOST REDIS_PORT=$REDIS_PORT REDIS_PASSWORD=$REDIS_PASSWORD QUEUE=$QUEUE COUNT=$COUNT BUILD_TOKEN=$BUILD_TOKEN sidekiq -c 1 -q publish_worker -q publish_worker_default -r ./lib/abf-worker.rb
}
prepare_and_run
