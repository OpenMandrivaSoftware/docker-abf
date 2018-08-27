#!/bin/bash
file_store_env(){
echo export RAILS_ENV="$RAILS_ENV"
echo export ABF_URL="$ABF_URL"
echo export SECRET_KEY_BASE="$SECRET_KEY_BASE"
echo export DATABASE_NAME="$DATABASE_NAME"
echo export DATABASE_HOST="$DATABASE_HOST"
echo export DATABASE_USERNAME="$DATABASE_USERNAME"
echo export DATABASE_PASSWORD="$DATABASE_PASSWORD"
echo export DATABASE_POOL="$DATABASE_POOL" # 5
echo export DATABASE_TIMEOUT="$DATABASE_TIMEOUT" # 5000
echo export RAILS_SERVE_STATIC_FILES="$RAILS_SERVE_STATIC_FILES"
echo export GLUSTER_STORAGE_SERVER="$GLUSTER_STORAGE_SERVER" # 172.17.0.25
echo export GIT_BRANCH="${GIT_BRANCH:-master}"
echo export MEMCACHIER_SERVERS="$MEMCACHIER_SERVERS"
echo export MEMCACHIER_USERNAME="$MEMCACHIER_USERNAME"
echo export MEMCACHIER_PASSWORD="$MEMCACHIER_PASSWORD"

}

prepare_repo(){
source /etc/profile
echo "prepare File-Store environment vars"
if [ ! -d "/file_store" ]; then
git clone https://github.com/OpenMandrivaSoftware/rosa-file-store.git -b $GIT_BRANCH /file_store
else
rm -rf /file_store
git config --global user.email "abf@openmandriva.org"
git config --global user.name "ABF"
git clone https://github.com/OpenMandrivaSoftware/rosa-file-store.git -b $GIT_BRANCH /file_store
fi
pushd /file_store
gem install bundler
gem install puma
bundle install --deployment --without development test --jobs 20 --retry 5
# Copy the database.yml.
cp config/database.yml.sample config/database.yml
# Copy the database.yml.
#cp config/application.yml.sample config/application.yml
#cp config/deploy.rb.sample config/deploy.rb
if [ ! -d "/uploads" ]; then
mkdir uploads
fi

popd
}

prepare_repo
pushd /file_store
rake db:create db:migrate
echo "update styles"
rake assets:precompile
puma -C config/puma.rb -t 8:16 -w 8
popd
