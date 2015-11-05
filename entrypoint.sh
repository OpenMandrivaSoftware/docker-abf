#!/bin/bash
set -x

abf_env(){

echo export RAILS_ENV="$RAILS_ENV"
echo export RACK_ENV="$RACK_ENV"
echo export DEVISE_PEPPER="$DEVISE_PEPPER"
echo export DEVISE_SECRET="$DEVISE_SECRET"
echo export GOOGLE_APP_ID="$GOOGLE_APP_ID"
echo export GOOGLE_APP_SECRET="$GOOGLE_APP_SECRET"
echo export FACEBOOK_APP_ID="$FACEBOOK_APP_ID"
echo export FACEBOOK_APP_SECRET="$FACEBOOK_APP_SECRET"
echo export DOWNLOADS_URL="$DOWNLOADS_URL"
echo export FEEDBACK_EMAIL="$FEEDBACK_EMAIL"
echo export FEEDBACK_CC="$FEEDBACK_CC"
echo export ROOT_PATH="$ROOT_PATH"
echo export GIT_PATH="$GIT_PATH"
echo export TMPFS_PATH="$TMPFS_PATH"
echo export DO_NOT_REPLY_EMAIL="$DO_NOT_REPLY_EMAIL"
echo export MAILER_HTTPS_URL="$MAILER_HTTPS_URL"
echo export GITHUB_SERVICES_ID="$GITHUB_SERVICES_ID"
echo export GITHUB_SERVICES_PORT="$GITHUB_SERVICES_PORT"
echo export REDIS_URL="$REDIS_URL"
echo export DATABASE_NAME="$DATABASE_NAME"
echo export DATABASE_HOST="$DATABASE_HOST"
echo export DATABASE_USERNAME="$DATABASE_USERNAME"
echo export DATABASE_PASSWORD="$DATABASE_PASSWORD"
echo export DATABASE_POOL="$DATABASE_POOL" # 5
echo export DATABASE_TIMEOUT="$DATABASE_TIMEOUT" # 5000
echo export FILE_STORE_URL="$FILE_STORE_URL"
echo export ABF_WORKER_PUBLISH_WORKERS_COUNT="$ABF_WORKER_PUBLISH_WORKERS_COUNT"
echo export ABF_WORKER_LOG_SERVER_HOST="$ABF_WORKER_LOG_SERVER_HOST"
echo export ABF_WORKER_LOG_SERVER_PORT="$ABF_WORKER_LOG_SERVER_PORT"

}

#abf_env >> /tmp/env
prepare_repo(){
echo "prepare ABF environment vars"
abf_env >> $HOME/envfile
echo "apply updated /etc/bashrc"
source $HOME/envfile
git clone https://github.com/OpenMandrivaSoftware/rosa-build.git -b docker /app/rosa-build
pushd /app/rosa-build 
cp Gemfile Gemfile.lock
gem install bundler
bundle install --without development test --jobs 20 --retry 5
# Copy the database.yml.
cp config/database.yml.sample config/database.yml
# Copy the database.yml.
cp config/application.yml.sample config/application.yml
popd
}
prepare_repo
