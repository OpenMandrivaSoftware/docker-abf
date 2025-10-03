ARCH=$(uname -m)

if [ "$#" = "0" ]; then
	CONTAINERS="createrepo publisher nginx repoclosure abf abf-service-sidekiq-worker isobuilder file-store redis"
else
	CONTAINERS="$@"
fi

for CONTAINER in $CONTAINERS; do
	case $CONTAINER in
	abf)
		SUBDIR="abf-service"
		;;
	abf-service-sidekiq-worker)
		SUBDIR="abf-service-sidekiq"
		;;
	isobuilder)
		SUBDIR="iso-builder"
		;;
	file-store)
		SUBDIR="oma-file-store"
		;;
	*)
		SUBDIR="abf-$CONTAINER"
		;;
	esac

	pushd $SUBDIR/
		if [ "$CONTAINER" = "createrepo" ]; then
			if [ "$ARCH" != "x86_64" ]; then
				sed -i -e '/ENV RARCH x86_64/d' Dockerfile.createrepo
			fi
		fi
		if [ -e Dockerfile.${CONTAINER} ]; then
			docker build --tag=openmandriva/${CONTAINER}:${ARCH} --file Dockerfile.${CONTAINER} .
		else
			docker build --tag=openmandriva/${CONTAINER}:${ARCH} --file Dockerfile .
		fi
		docker push openmandriva/${CONTAINER}:${ARCH}
	popd
	docker manifest create openmandriva/$i:latest \
		--amend openmandriva/$i:x86_64 \
		--amend openmandriva/$i:aarch64
	docker manifest annotate openmandriva/$i:latest openmandriva/$i:x86_64 --os linux --arch amd64
	docker manifest annotate openmandriva/$i:latest openmandriva/$i:aarch64 --os linux --arch arm64
	docker manifest push openmandriva/$i:latest
done
