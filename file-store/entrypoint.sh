#!/bin/sh

errorCatch() {
    printf "%s\n" '-> Something went wrong. Exiting'.
    exit 1
}

# Don't leave potentially dangerous stuff if we had to error out...
trap errorCatch ERR SIGHUP SIGINT SIGTERM

file_store_env(){
    printf '%s\n' "export RAILS_ENV=$RAILS_ENV"
    printf '%s\n' "export ABF_URL=$ABF_URL"
    printf '%s\n' "export SECRET_KEY_BASE=$SECRET_KEY_BASE"
    printf '%s\n' "export DATABASE_NAME=$DATABASE_NAME"
    printf '%s\n' "export DATABASE_HOST=$DATABASE_HOST"
    printf '%s\n' "export DATABASE_USERNAME=$DATABASE_USERNAME"
    printf '%s\n' "export DATABASE_PASSWORD=$DATABASE_PASSWORD"
    printf '%s\n' "export DATABASE_POOL=$DATABASE_POOL" # 5
    printf '%s\n' "export DATABASE_TIMEOUT=$DATABASE_TIMEOUT" # 5000
    printf '%s\n' "export RAILS_SERVE_STATIC_FILES=$RAILS_SERVE_STATIC_FILES"
    printf '%s\n' "export GLUSTER_STORAGE_SERVER=$GLUSTER_STORAGE_SERVER" # 172.17.0.25
    printf '%s\n' "export GIT_BRANCH=${GIT_BRANCH:-master}"
    printf '%s\n' "export MEMCACHIER_SERVERS=$MEMCACHIER_SERVERS"
    printf '%s\n' "export MEMCACHIER_USERNAME=$MEMCACHIER_USERNAME"
    printf '%s\n' "export MEMCACHIER_PASSWORD=$MEMCACHIER_PASSWORD"
}

prepare_repo(){
    . /etc/profile
    printf '%s\n' 'Prepare File-Store environment vars.'
    if [ ! -d '/app/file_store' ]; then
	git clone https://github.com/OpenMandrivaSoftware/rosa-file-store.git -b $GIT_BRANCH /app/file_store
    else
	rm -rf /app/file_store
	git config --global user.email "abf@openmandriva.org"
	git config --global user.name "ABF"
	git clone https://github.com/OpenMandrivaSoftware/rosa-file-store.git -b $GIT_BRANCH /app/file_store
    fi
    cd  /app/file_store
    gem install bundler -v 1.17.3
    [ $? != '0' ] && errorCatch
    gem install puma
    [ $? != '0' ] && errorCatch
    bundle install --deployment --without development test --jobs 20 --retry 5
    [ $? != '0' ] && errorCatch
# Copy the database.yml.
    cp config/database.yml.sample config/database.yml
# Copy the database.yml.
#cp config/application.yml.sample config/application.yml
#cp config/deploy.rb.sample config/deploy.rb
    [ ! -d '/uploads' ] && mkdir uploads
    cd -
}

prepare_repo
cd /app/file_store
rake db:create db:migrate
[ $? != '0' ] && errorCatch
printf '%s\n' "Update styles"
rake assets:precompile
[ $? != '0' ] && errorCatch
puma -C config/puma.rb -t 8:16 -w 8
[ $? != '0' ] && errorCatch
cd -
