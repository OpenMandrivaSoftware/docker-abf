## Quickstart

Create builder image:

```bash
docker build --tag=openmandriva/isobuilder:$(uname -m) --file Dockerfile.isobuilder .
docker manifest rm openmandriva/isobuilder:latest || :
docker manifest create openmandriva/isobuilder:latest \
    openmandriva/isobuilder:x86_64 \
    openmandriva/isobuilder:aarch64
docker manifest annotate openmandriva/isobuilder:latest openmandriva/isobuilder:x86_64 --os linux --arch amd64
docker manifest annotate openmandriva/isobuilder:latest openmandriva/isobuilder:aarch64 --os linux --arch arm64
docker manifest push openmandriva/isobuilder:latest
```

## Remove stopped containers
```bash
docker rm -v $(docker ps -a -q -f status=exited)
```

## Run abf iso builder
```bash
docker run -ti --rm --privileged=true -v /var/run/docker.sock:/var/run/docker.sock \
	-e BUILD_TOKEN="your_token"  -e QUEUE="iso_worker" \
	-e REDIS_HOST="host" -e REDIS_PORT="6379" openmandriva/isobuilder
```

## Prepare Environment
## ARMv7
```bash
/etc/binfmt.d/arm.conf
```
```bash
:arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-binfmt:P
```

## ARM64 (aarch64)
```bash
/etc/binfmt.d/aarch64.conf
```
```bash
:aarch64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-aarch64-binfmt:P
```
