#!/bin/sh
PLATFORMS="$@"
if [ -z "$PLATFORMS" ]; then
	PLATFORMS="znver1 x86_64 aarch64 i686 armv7hnl riscv64"
fi
echo "Rebuilding metadata for $PLATFORMS"
for i in $PLATFORMS; do
	if ! [ -d /share/platforms/cooker/repository/$i/main/release ]; then
		echo "$i doesn't seem to be a valid platform" >&2
		continue
	fi
	/usr/bin/docker run --rm -v /var/lib/openmandriva/abf-downloads:/share/platforms openmandriva/createrepo /share/platforms/cooker/repository/$i/main/release/ regenerate &
done
wait
