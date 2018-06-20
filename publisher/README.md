## Quickstart

Create publisher image:

```bash
docker build --tag=openmandriva/publisher --file Dockerfile.publisher .
```

```bash
regen.sh armv7hnl - regenerates DNF metadata for selected arch
regen.sh armv7hnl aarch64 - regenerates DNF metadata for selected arches
regen.sh regenerates it for all arches
```
