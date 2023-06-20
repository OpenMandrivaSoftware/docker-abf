#!/bin/sh

# Modified by tpgxyz@gmail.com
# Modified by bero@lindev.ch
# Call this script with path where createrepo_c will run
# and call with regenerate paramater to build repodata
# from scratch.

run_createrepo() {
	REPOSITORY="$1"
	REGENERATE="$2"

	# Skip trailing slashes so they don't mess with the origin
	echo "${REPOSITORY}" |grep -q '/$' && REPOSITORY=$(echo ${REPOSITORY} |rev |cut -b2- |rev)

	[ ! -d "${REPOSITORY}" ] && printf '%s\n' "Directory ${REPOSITORY} does not exist. Exiting." && exit 1
	printf '%s\n' "Starting regenerating repodata in ${REPOSITORY}"

	if [ ! -e "${REPOSITORY}"/repodata ] || [ "$2" = 'regenerate' ]; then
		# release/updates/testing
		RELEASETYPE="$(echo ${REPOSITORY} |rev |cut -d/ -f1 |rev)"
		# main/unsupported/restricted/non-free/...
		REPOTYPE="$(echo ${REPOSITORY} |rev |cut -d/ -f2 |rev)"
		# CPU architecture
		ARCH="$(echo ${REPOSITORY} |rev |cut -d/ -f3 |rev)"
		# cooker/rolling/5.0/...
		VERSION="$(echo ${REPOSITORY} |rev |cut -d/ -f5 |rev)"

		printf '%s\n' "Regenerating repodata from scratch in ${REPOSITORY}"
		createmd -o openmandriva-${VERSION}-${ARCH}-${REPOTYPE}-${RELEASETYPE} "${REPOSITORY}"
		rc=$?
	else
		printf '%s\n' "Regenerating and updating repodata in ${REPOSITORY}"
		createmd -u "${REPOSITORY}"
		rc=$?
		if [ "${rc}" != '0' ]; then
			printf '%s\n' "Failed updating repodata in ${REPOSITORY}, trying regeneration from scratch"
			run_createrepo "${REPOSITORY}" "regenerate"
			return
		fi
	fi

	if [ "${rc}" != '0' ]; then
		printf '%s\n' "Failed regenerating repodata in ${REPOSITORY}"
	else
		printf '%s\n' "Finished regenerating repodata in ${REPOSITORY}"
	fi
}

if [ -n "$1" ]; then
	run_createrepo "$1" "$2"
else
	REPOSITORY="/share/platforms/cooker/repository"
	[ ! -d "${REPOSITORY}" ] && printf '%s\n' "Directory ${REPOSITORY} does not exist. Exiting." && exit 1

	for i in i686 x86_64 aarch64 riscv64 armv7hnl znver1 SRPMS; do
		for j in main unsupported non-free restricted debug_main debug_unsupported debug_non-free debug_restricted; do
			for k in release updates testing; do
				run_createrepo "${REPOSITORY}/${i}/${j}/${k}"
			done
		done
	done
fi

exit 0
