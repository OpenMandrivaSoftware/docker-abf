#!/bin/bash
file_store_env(){
echo export RAILS_ENV="$RAILS_ENV"
echo export HOST_URL="$HOST_URL"
echo export SECRET_TOKEN="$SECRET_TOKEN"
echo export DATABASE_NAME="$DATABASE_NAME"
echo export DATABASE_HOST="$DATABASE_HOST"
echo export DATABASE_USERNAME="$DATABASE_USERNAME"
echo export DATABASE_PASSWORD="$DATABASE_PASSWORD"
echo export DATABASE_POOL="$DATABASE_POOL" # 5
echo export DATABASE_TIMEOUT="$DATABASE_TIMEOUT" # 5000
echo export GLUSTER_STORAGE_SERVER="$GLUSTER_STORAGE_SERVER" # 172.17.0.25
}

prepare_repo(){
echo "prepare File-Store environment vars"
file_store_env >> /app/envfile
echo "apply updated env file"
source /app/envfile
if [ ! -d "/app/file_store" ]; then
git clone https://github.com/OpenMandrivaSoftware/rosa-file-store.git -b master /app/file_store
else
pushd /app/file_store
git pull
popd
fi
pushd /app/file_store
gem install bundler
bundle install --without development test --jobs 20 --retry 5
# Copy the database.yml.
cp config/database.yml.sample config/database.yml
# Copy the database.yml.
cp config/application.yml.sample config/application.yml
cp config/deploy.rb.sample config/deploy.rb
if [ ! -d "/app/file_store/uploads" ]; then
mkdir uploads
fi
mount.glusterfs $GLUSTER_STORAGE_SERVER:/fs-data /app/file_store/uploads/
popd
}

prepare_repo
pushd /app/file_store
rake db:create db:migrate
echo "update styles"
rake assets:precompile
bundle exec unicorn  -l /app/file_store/file_store_unicorn.sock -E production -c config/unicorn.rb
popd
