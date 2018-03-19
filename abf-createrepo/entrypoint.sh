#!/bin/sh

# Modified by tpgxyz@gmail.com
# Call this script with path where createrepo_c will run
# and call with regenerate paramater to build repodata
# from scratch.

run_createrepo() {
    REPOSITORY="$1"
    REGENERATE="$2"

    [ ! -d "${REPORITORY}" ] && printf '%s\n' "Directory ${REPORITORY} does not exist. Exiting." && exit 1
    printf '%s\n' "Starting regenerating repodata in ${REPOSITORY}"

    if [ ! -e "${REPOSITORY}"/repodata ] || [ "$2" = 'regenerate' ]; then
	printf '%s\n' "Regenerating repodata from scratch in ${REPOSITORY}"
	rm -rf "${REPOSITORY}"/.repodata
	mkdir -p "${REPOSITORY}"/repodata
	chown root:root "${REPOSITORY}"/repodata
	chmod 0755 "${REPOSITORY}"/repodata
	createrepo_c --no-database --workers=10 --general-compress-type=xz --ignore-lock "${REPOSITORY}"
	rc=$?
    else
	printf '%s\n' "Regenerating and updating repodata in ${REPOSITORY}"
	if [ -e "${REPOSITORY}"/.repodata ]; then
	    printf '%s\n' "Previous .repodata exists in ${REPOSITORY}. Removing it."
	    rm -rf "${REPOSITORY}"/.repodata
	fi
	    createrepo_c --no-database --workers=10 --general-compress-type=xz --update "${REPOSITORY}"
	    rc=$?
    fi

    if [ "${rc}" != '0' ]; then
	printf '%s\n' "Failed regenerating repodata in ${REPOSITORY}"
	else
	    printf '%s\n' "Finished regenerating repodata in ${REPOSITORY}"
    fi

    if [ -e "${REPOSITORY}"/repodata ]; then
	[ $(stat -c "%U" "${REPOSITORY}"/repodata ) != 'root' ] && chown root:root "${REPOSITORY}"/repodata
	[ $(stat -c "%a" "${REPOSITORY}"/repodata ) != '755' ] && chmod 0755 "${REPOSITORY}"/repodata
    fi

}

if [ -n "$1" ];
    run_createrepo "$1" "$2"
else

    REPOSITORY="/share/platforms/cooker/repository"
    [ ! -d "${REPORITORY}" ] && printf '%s\n' "Directory ${REPORITORY} does not exist. Exiting." && exit 1

    for i in i686 x86_64 aarch64 armv7hl SRPMS; do
	for j in main contrib non-free restricted debug_main debug_contrib debug_non-free debug_restricted; do
	    for k in release updates testing; do
		run_createrepo "${REPORITORY}/${i}/${j}/${k}"
	    done
	done
    done

fi

exit 0
