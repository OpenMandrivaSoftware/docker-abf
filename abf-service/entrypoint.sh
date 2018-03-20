#!/bin/bash
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
echo export HOST_URL="$HOST_URL"
echo export GIT_PROJECT_URL="$GIT_PROJECT_URL"
echo export GIT_BRANCH="$GIT_BRANCH"
echo export GITHUB_LOGIN="$GITHUB_LOGIN"
echo export GITHUB_PASSWORD="$GITHUB_PASSWORD"
# redis://user:password.openmandriva.org:6379
echo export REDIS_USER="$REDIS_USER"
echo export REDIS_PASSWORD="$REDIS_PASSWORD"
echo export REDIS_HOST="$REDIS_HOST"
echo export REDIS_URL="redis://$REDIS_USER:$REDIS_PASSWORD@$REDIS_HOST"
echo export DATABASE_NAME="$DATABASE_NAME"
echo export DATABASE_HOST="$DATABASE_HOST"
echo export DATABASE_USERNAME="$DATABASE_USERNAME"
echo export DATABASE_PASSWORD="$DATABASE_PASSWORD"
echo export DATABASE_POOL="$DATABASE_POOL" # 5
echo export DATABASE_TIMEOUT="$DATABASE_TIMEOUT" # 5000
echo export FILE_STORE_URL="$FILE_STORE_URL"
echo export PUMA_THREADS="$PUMA_THREADS"
echo export PUMA_WORKERS="$PUMA_WORKERS"
echo export ABF_WORKER_PUBLISH_WORKERS_COUNT="$ABF_WORKER_PUBLISH_WORKERS_COUNT"
echo export ABF_WORKER_LOG_SERVER_HOST="$ABF_WORKER_LOG_SERVER_HOST"
echo export ABF_WORKER_LOG_SERVER_PORT="$ABF_WORKER_LOG_SERVER_PORT"
echo export GITHUB_REPO_BOT_LOGIN="$GITHUB_REPO_BOT_LOGIN"
echo export GITHUB_REPO_BOT_PASSWORD="$GITHUB_REPO_BOT_PASSWORD"
}

prepare_repo(){
source /etc/profile
echo "prepare ABF environment vars"
abf_env > /app/envfile
echo "apply updated env file"
source /app/envfile
if [ ! -d "/app/rosa-build" ]; then
# GIT_PROJECT_URL = https://github.com/OpenMandrivaSoftware/rosa-build.git
# GIT_BRANCH = docker
git clone $GIT_PROJECT_URL -b $GIT_BRANCH /app/rosa-build
else
rm -rf /app/rosa-build
git config --global user.email "abf@openmandriva.org"
git config --global user.name "ABF"
# GIT_PROJECT_URL = https://github.com/OpenMandrivaSoftware/rosa-build.git
# GIT_BRANCH = docker
git clone $GIT_PROJECT_URL -b $GIT_BRANCH /app/rosa-build
fi
pushd /app/rosa-build
rm -f Gemfile.lock
gem install bundler
bundle install --full-index --without development test --jobs 20 --retry 10 --verbose
# Copy the database.yml.
cp config/database.yml.sample config/database.yml
# Copy the database.yml.
cp config/application.yml.sample config/application.yml
echo "update styles"
rake assets:precompile
# save user icons to host
mkdir -p public/system/users/
rm -rf public/system/users/avatars/
ln -s /avatars public/system/users/avatars
# execute me on empty postgresql database
# load db schema
#rake db:schema:load
popd
}
prepare_repo
pushd /app/rosa-build
puma -C config/puma/production.rb
popd
