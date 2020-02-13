
pushd abf-createrepo/
	docker build --tag=openmandriva/createrepo --file Dockerfile.createrepo .
popd

pushd publisher
	docker build --tag=openmandriva/publisher --file Dockerfile.publisher .
popd

pushd abf-genhdlists
	docker build --tag=openmandriva/genhdlists2 --file Dockerfile.genhdlists2 .
popd

pushd abf-nginx
	docker build --tag=openmandriva/nginx --file Dockerfile .
popd

pushd abf-repoclosure
	docker build --tag=openmandriva/repoclosure --file Dockerfile.repoclosure .
popd

pushd abf-service
	docker build --tag=openmandriva/abf --file Dockerfile .
popd

pushd abf-service-sidekiq
	docker build --tag=openmandriva/abf-service-sidekiq-worker:latest --file Dockerfile .
popd

pushd iso-builder
	docker build --tag=openmandriva/isobuilder --file Dockerfile.isobuilder .
popd

pushd oma-file-store
	docker build --tag=openmandriva/file-store --file Dockerfile .
popd

docker push openmandriva/createrepo
docker push openmandriva/publisher
docker push openmandriva/genhdlists2
docker push openmandriva/nginx
docker push openmandriva/repoclosure
docker push openmandriva/abf
docker push openmandriva/abf-service-sidekiq-worker
docker push openmandriva/isobuilder
docker push openmandriva/file-store

