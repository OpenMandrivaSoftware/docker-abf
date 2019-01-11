#!/bin/sh

errorCatch() {
    printf "%s\n" '-> Something went wrong. Exiting'.
    exit 1
}

# Don't leave potentially dangerous stuff if we had to error out...
trap errorCatch ERR SIGHUP SIGINT SIGTERM

prepare_env(){
    ./etc/profile
    printf "%s\n" 'Apply updated env file'
    if [ -f '/app/envfile' ]; then
	. /app/envfile
    fi

    cd /app/rosa-build
    gem install bundler -v 1.17.3
    [ $? != '0' ] && errorCatch
    bundle install --without development test --jobs 20 --retry 5
    [ $? != '0' ] && errorCatch
    cd -
}

prepare_env
cd /app/rosa-build
sidekiq -q iso_worker_observer -q low -q middle -q notification -q publish_observer -q rpm_worker_observer -c 5
[ $? != '0' ] && errorCatch
cd -
