### Build

docker build --tag=openmandriva/gluster-main --file Dockerfile.main .
docker build --tag=openmandriva/gluster-client --file Dockerfile.client .

### Run

# Server
docker run -td --privileged=true -h gluster-main --name gluster-main -p 111:111 -p 24007:24007 -p 24008:24008 -p 24009:24009 -p 49152:49152 -p 49153:49153 -v /var/lib/glusterd/:/var/lib/glusterd/ -v /home/gluster-storage:/mnt/data openmandriva/gluster-main

# Client
docker run -td --privileged=true -h gluster-client --name gluster-client -p 111:111 -p 24007:24007 -p 24008:24008 -p 24009:24009 -p 49152:49152 -p 49153:49153 -v /var/lib/glusterd/:/var/lib/glusterd/ -v /home/gluster-storage:/mnt/data openmandriva/openmandriva2014.0 /bin/bash
