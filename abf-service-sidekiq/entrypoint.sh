#!/bin/bash

prepare_env(){
source /etc/profile
echo "apply updated env file"
if [ -f "/app/envfile" ]; then
source /app/envfile
fi

pushd /app/rosa-build
gem install bundler -v 1.16.1
bundle install --without development test --jobs 20 --retry 5
popd
}

prepare_env
pushd /app/rosa-build
sidekiq -q iso_worker_observer -q low -q middle -q notification -q publish_observer -q rpm_worker_observer -c 5
popd
