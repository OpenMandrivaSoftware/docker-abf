## Quickstart
Build container

```bash
docker build --tag=openmandriva/repoclosure --file Dockerfile .
```

Create report:

```bash
/usr/bin/docker run -d --rm -v /var/lib/openmandriva/docker-abf/abf-repoclosure/config.json:/repoclosure/config.json -v /var/lib/openmandriva/omv/repoclosure:/repoclosure-output openmandriva/repoclosure

```
