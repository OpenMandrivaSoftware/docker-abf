#!/bin/sh

errorCatch() {
    printf "%s\n" '-> Something went wrong. Exiting'.
    exit 1
}

# Don't leave potentially dangerous stuff if we had to error out...
trap errorCatch ERR SIGHUP SIGINT SIGTERM

abf_env() {
    printf '%\n' "export RAILS_ENV=$RAILS_ENV"
    printf '%\n' "export RACK_ENV=$RACK_ENV"
    printf '%\n' "export DEVISE_PEPPER=$DEVISE_PEPPER"
    printf '%\n' "export DEVISE_SECRET=$DEVISE_SECRET"
    printf '%s\n' "export GOOGLE_APP_ID=$GOOGLE_APP_ID"
    printf '%s\n' "export GOOGLE_APP_SECRET=$GOOGLE_APP_SECRET"
    printf '%s\n' "export FACEBOOK_APP_ID=$FACEBOOK_APP_ID"
    printf '%s\n' "export FACEBOOK_APP_SECRET=$FACEBOOK_APP_SECRET"
    printf '%s\n' "export DOWNLOADS_URL=$DOWNLOADS_URL"
    printf '%s\n' "export FEEDBACK_EMAIL=$FEEDBACK_EMAIL"
    printf '%s\n' "export FEEDBACK_CC=$FEEDBACK_CC"
    printf '%s\n' "export ROOT_PATH=$ROOT_PATH"
    printf '%s\n' "export GIT_PATH=$GIT_PATH"
    printf '%s\n' "export TMPFS_PATH=$TMPFS_PATH"
    printf '%s\n' "export DO_NOT_REPLY_EMAIL=$DO_NOT_REPLY_EMAIL"
    printf '%s\n' "export MAILER_HTTPS_URL=$MAILER_HTTPS_URL"
    printf '%s\n' "export GITHUB_SERVICES_ID=$GITHUB_SERVICES_ID"
    printf '%s\n' "export GITHUB_SERVICES_PORT=$GITHUB_SERVICES_PORT"
    printf '%s\n' "export HOST_URL=$HOST_URL"
    printf '%s\n' "export GIT_PROJECT_URL=$GIT_PROJECT_URL"
    printf '%s\n' "export GIT_BRANCH=$GIT_BRANCH"
    printf '%s\n' "export GITHUB_LOGIN=$GITHUB_LOGIN"
    printf '%s\n' "export GITHUB_PASSWORD=$GITHUB_PASSWORD"
# redis://user:password.openmandriva.org:6379
    printf '%s\n' "export REDIS_USER=$REDIS_USER"
    printf '%s\n' "export REDIS_PASSWORD=$REDIS_PASSWORD"
    printf '%s\n' "export REDIS_HOST=$REDIS_HOST"
    printf '%s\n' "export REDIS_URL=redis://$REDIS_USER:$REDIS_PASSWORD@$REDIS_HOST"
    printf '%s\n' "export DATABASE_NAME=$DATABASE_NAME"
    printf '%s\n' "export DATABASE_HOST=$DATABASE_HOST"
    printf '%s\n' "export DATABASE_USERNAME=$DATABASE_USERNAME"
    printf '%s\n' "export DATABASE_PASSWORD=$DATABASE_PASSWORD"
    printf '%s\n' "export DATABASE_POOL=$DATABASE_POOL" # 5
    printf '%s\n' "export DATABASE_TIMEOUT=$DATABASE_TIMEOUT" # 5000
    printf '%s\n' "export FILE_STORE_URL=$FILE_STORE_URL"
    printf '%s\n' "export PUMA_THREADS=$PUMA_THREADS"
    printf '%s\n' "export PUMA_WORKERS=$PUMA_WORKERS"
    printf '%s\n' "export ABF_WORKER_PUBLISH_WORKERS_COUNT=$ABF_WORKER_PUBLISH_WORKERS_COUNT"
    printf '%s\n' "export ABF_WORKER_LOG_SERVER_HOST=$ABF_WORKER_LOG_SERVER_HOST"
    printf '%s\n' "export ABF_WORKER_LOG_SERVER_PORT=$ABF_WORKER_LOG_SERVER_PORT"
    printf '%s\n' "export GITHUB_REPO_BOT_LOGIN=$GITHUB_REPO_BOT_LOGIN"
    printf '%s\n' "export GITHUB_REPO_BOT_PASSWORD=$GITHUB_REPO_BOT_PASSWORD"
}

prepare_repo() {
    . /etc/profile
    printf "%s\n" 'Prepare ABF environment vars'
    abf_env > /app/envfile
    printf "%s\n" 'Apply updated env file'
    . /app/envfile
    if [ ! -d '/app/rosa-build' ]; then
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
    cd /app/rosa-build

# (tpg) we still use bundler < 2.0
    gem install bundler:1.17.3 tzinfo-data
    [ $? != '0' ] && errorCatch

    bundle install --full-index --without development test --jobs 20 --retry 10 --verbose
    [ $? != '0' ] && errorCatch

# Copy the database.yml.
    cp config/database.yml.sample config/database.yml
# Copy the database.yml.
    cp config/application.yml.sample config/application.yml
    printf "%s\n" '"Update styles'
    rake assets:precompile
    [ $? != '0' ] && errorCatch
# save user icons to host
    mkdir -p public/system/users/
    rm -rf public/system/users/avatars/
    ln -s /avatars public/system/users/avatars
# execute me on empty postgresql database
# load db schema
#rake db:schema:load
    cd -
}

prepare_repo
cd /app/rosa-build
puma -C config/puma/production.rb
[ $? != '0' ] && errorCatch
cd -
