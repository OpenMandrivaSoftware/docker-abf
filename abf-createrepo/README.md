## Quickstart
Build container

```bash
docker build --tag=openmandriva/createrepo --file Dockerfile.createrepo .
```

To deploy the container, either update the publisher container
or run ```docker pull openmandriva/createrepo``` inside it.
