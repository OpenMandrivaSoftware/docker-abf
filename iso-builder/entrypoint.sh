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
#	printf '%s\n' "export QUEUE=publish_worker,publish_worker_default"
    printf '%s\n' "export QUEUE=$QUEUE"
    printf '%s\n' "export COUNT=$COUNT"
    printf '%s\n' "export BUILD_TOKEN=$BUILD_TOKEN"

}

prepare_and_run() {
    . /etc/profile
    printf '%s\n' 'Prepare ABF ISO builder environment.'
    printf '%s\n' 'git clone docker-iso-worker code'
    cd
    if [ ! -d "${HOME}/docker-iso-worker" ]; then
	git clone https://github.com/OpenMandrivaSoftware/docker-iso-worker.git
    else
	rm -rf ${HOME}/docker-iso-worker
	git clone https://github.com/OpenMandrivaSoftware/docker-iso-worker.git
    fi
    cd docker-iso-worker
    export PATH="${PATH}:$HOME/bin"
# skip $ARCH before we build hiredis gem
    unset ARCH
    gem install bundler
    [ $? != '0' ] && errorCatch
    bundle install
    [ $? != '0' ] && errorCatch
    REDIS_HOST=$REDIS_HOST REDIS_PORT=$REDIS_PORT REDIS_PASSWORD=$REDIS_PASSWORD QUEUE=$QUEUE COUNT=$COUNT BUILD_TOKEN=$BUILD_TOKEN sidekiq -q iso_worker -c 1 -r ./lib/abf-worker.rb
    [ $? != '0' ] && errorCatch
}

prepare_and_run
