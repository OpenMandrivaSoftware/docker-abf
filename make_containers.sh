ARCH=$(uname -m)

pushd abf-createrepo/
	docker build --tag=openmandriva/createrepo:${ARCH} --file Dockerfile.createrepo .
popd

pushd publisher
	docker build --tag=openmandriva/publisher:${ARCH} --file Dockerfile.publisher .
popd

#pushd abf-genhdlists
#	docker build --tag=openmandriva/genhdlists2:${ARCH} --file Dockerfile.genhdlists2 .
#popd

pushd abf-nginx
	docker build --tag=openmandriva/nginx:${ARCH} --file Dockerfile .
popd

pushd abf-repoclosure
	docker build --tag=openmandriva/repoclosure:${ARCH} --file Dockerfile.repoclosure .
popd

pushd abf-service
	docker build --tag=openmandriva/abf:${ARCH} --file Dockerfile .
popd

pushd abf-service-sidekiq
	docker build --tag=openmandriva/abf-service-sidekiq-worker:${ARCH} --file Dockerfile .
popd

pushd iso-builder
	docker build --tag=openmandriva/isobuilder:${ARCH} --file Dockerfile.isobuilder .
popd

pushd oma-file-store
	docker build --tag=openmandriva/file-store:${ARCH} --file Dockerfile .
popd

pushd abf-redis
	docker build --tag=openmandriva/redis:${ARCH} --file Dockerfile .
popd

docker push openmandriva/createrepo:${ARCH}
docker push openmandriva/publisher:${ARCH}
docker push openmandriva/genhdlists2:${ARCH}
docker push openmandriva/nginx:${ARCH}
docker push openmandriva/repoclosure:${ARCH}
docker push openmandriva/abf:${ARCH}
docker push openmandriva/abf-service-sidekiq-worker:${ARCH}
docker push openmandriva/isobuilder:${ARCH}
docker push openmandriva/file-store:${ARCH}
docker push openmandriva/redis:${ARCH}
