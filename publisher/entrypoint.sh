#!/bin/sh

errorCatch() {
    printf "%s\n" '-> Something went wrong. Exiting'.
    exit 1
}

# Don't leave potentially dangerous stuff if we had to error out...
trap errorCatch ERR SIGHUP SIGINT SIGTERM

abf_env() {
    printf '%s\n' "export REDIS_HOST=$REDIS_HOST"
    printf '%s\n' "export REDIS_PORT=$REDIS_PORT"
    printf '%s\n' "export REDIS_PASSWORD=$REDIS_PASSWORD"
#	printf "%s\n' "export QUEUE=publish_worker,publish_worker_default"
    printf '%s\n' "export QUEUE=$QUEUE"
    printf '%s\n' "export COUNT=$COUNT"
    printf '%s\n' "export BUILD_TOKEN=$BUILD_TOKEN"
    printf '%s\n' "export GIT_BRANCH=$GIT_BRANCH"
}

prepare_and_run() {
    . /etc/profile
    printf '%s\n' 'Prepare ABF publisher environment.'
    printf '%s\n' 'git clone docker-publish-worker code.'
    cd
    git clone https://github.com/OpenMandrivaSoftware/docker-publish-worker.git -b $GIT_BRANCH
    cd docker-publish-worker
    export PATH="${PATH}:/usr/local/rvm/bin"
# skip $ARCH before we build hiredis gem
    unset ARCH
    command -v rvm
    gem install bundler -v 1.17.3
    [ $? != '0' ] && errorCatch
    bundle install --without development
    [ $? != '0' ] && errorCatch
    REDIS_HOST=$REDIS_HOST REDIS_PORT=$REDIS_PORT REDIS_PASSWORD=$REDIS_PASSWORD QUEUE=$QUEUE COUNT=$COUNT BUILD_TOKEN=$BUILD_TOKEN sidekiq -c 1 -q publish_worker -q publish_worker_default -r ./lib/abf-worker.rb
    [ $? != '0' ] && errorCatch
}

prepare_and_run
