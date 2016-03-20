#!/bin/bash

prepare_env(){
source /etc/profile
echo "apply updated env file"
if [ -f "/app/envfile" ]; then
source /app/envfile
fi

pushd /app/rosa-build 
gem install bundler
bundle install --without development test --jobs 20 --retry 5
popd
}

prepare_env
pushd /app/rosa-build
bundle exec rake resque:scheduler
popd
