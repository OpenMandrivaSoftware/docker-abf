#!/bin/bash
# file-store
server1="$SERVER1"
# abf
server2="$SERVER2"
# new server
server3="$SERVER3"
scommand="glusterd"
VOLUME=fs-data

run_glusterd_and_friends() {
	echo "run daemon:$scommand"
	$scommand
	gluster peer probe $server1
# add here if statement
	gluster peer probe $server2
	echo "show pool list"
	gluster pool list
	if [ ! -f /mnt/data/.notfirstrun ]; then
	gluster volume create $VOLUME transport tcp $server1:/mnt/data $server2:/mnt/data/ force
	touch /mnt/data/.notfirstrun
	echo "not first run" >> /mnt/data/.notfirstrun
	fi
	gluster volume status
	gluster volume start $VOLUME
	# server1 is file-store.omv
	# gluster volume set $VOLUME auth.allow $server1
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
