#!/bin/sh
VERSION="cooker"
if [ "$1" = "-v" ]; then
	shift
	VERSION="$1"
	shift
fi
REPOSITORY=main
if [ "$1" = "-r" ]; then
	shift
	REPOSITORY="$1"
	shift
fi
PLATFORMS="$@"
if [ -z "$PLATFORMS" ]; then
	PLATFORMS="znver1 x86_64 aarch64 i686 armv7hnl riscv64"
fi
echo "Rebuilding metadata for $PLATFORMS"
for i in $PLATFORMS; do
	if ! [ -d /var/lib/openmandriva/abf-downloads/$VERSION/repository/$i/$REPOSITORY/release ]; then
		echo "$i doesn't seem to be a valid platform" >&2
		continue
	fi
	/usr/bin/docker run --rm -v /var/lib/openmandriva/abf-downloads:/share/platforms openmandriva/createrepo /share/platforms/$VERSION/repository/$i/$REPOSITORY/release/ regenerate &
done
wait
