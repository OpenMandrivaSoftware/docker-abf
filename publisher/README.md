## Quickstart

Create publisher image:

```bash
docker build --tag=openmandriva/publisher --file Dockerfile.publisher .
```

```bash
regen.sh armv7hl - regenerates DNF metadata for selected arch
regen.sh regenerates it for all arches
```
