#!/bin/bash
server1="$SERVER1"
server2="$SERVER2"
server3="$SERVER3"
scommand="glusterd"

run_glusterd_and_friends() {
	echo "run daemon:$scommand"
	$scommand
	gluster peer probe $server1
# add here if statement
	gluster peer probe $server2
	echo "show pool list"
	gluster pool list
	if [ ! -f /mnt/data/.notfirstrun ]; then
	gluster volume create fs-data transport tcp $server1:/mnt/data $server2:/mnt/data/ force
	touch /mnt/data/.notfirstrun
	echo "not first run" >> /mnt/data/.notfirstrun
	fi
	gluster volume start fs-data
	#mount.glusterfs $server1:/fs-data /mnt/file-store
}

infinite_loop() {
while :
do
	echo "Press [CTRL+C] to stop.."
	sleep 3600
done
}

run_glusterd_and_friends
infinite_loop
