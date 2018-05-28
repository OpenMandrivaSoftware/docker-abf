#!/bin/sh
PLATFORMS="$@"
if [ -z "$PLATFORMS" ]; then
	PLATFORMS="x86_64 aarch64 i686 armv7hnl"
fi
echo "Rebuilding metadata for $PLATFORMS"
for i in $PLATFORMS; do
	if ! [ -d /share/platforms/cooker/repository/$i/main/release ]; then
		echo "$i doesn't seem to be a valid platform" >&2
		continue
	fi
	/usr/bin/docker run --rm -v /home/abf-downloads:/share/platforms openmandriva/createrepo /share/platforms/cooker/repository/$i/main/release/ regenerate &
done
wait
