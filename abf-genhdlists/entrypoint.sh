#!/bin/sh

# Modified by tpgxyz@gmail.com
# Modified by bero@lindev.ch
# Call this script with path where createrepo_c will run
# and call with regenerate paramater to build repodata
# from scratch.

run_createrepo() {
    REPOSITORY="$1"
    REGENERATE="$2"

    [ ! -d "${REPOSITORY}" ] && printf '%s\n' "Directory ${REPOSITORY} does not exist. Exiting." && exit 1
    printf '%s\n' "Starting regenerating repodata in ${REPOSITORY}"
    if [ ! -e "${REPOSITORY}"/media_info ] || [ "$2" = 'regenerate' ]; then
        printf '%s\n' "Regenerating repodata from scratch in ${REPOSITORY}"
        rm -rf "${REPOSITORY}"/media_info
	XZ_OPT="-7 -T0" /usr/bin/genhdlist2 -v --nolock --allow-empty-media --versioned --synthesis-filter='.cz:xz -7 -T0' --xml-info --xml-info-filter='.lzma:xz -7 -T0' --no-hdlist --no-bad-rpm ${REPOSITORY}
        rc=$?
    else
        printf '%s\n' "Regenerating and updating media_info in ${REPOSITORY}"
	XZ_OPT="-7 -T0" /usr/bin/genhdlist2 -v --nolock --allow-empty-media --versioned --xml-info --xml-info-filter='.lzma:lzma -0 --text' --no-hdlist --merge --no-bad-rpm ${REPOSITORY}
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

    if [ -e "${REPOSITORY}"/media_info ]; then
        [ $(stat -c "%U" "${REPOSITORY}"/media_info ) != 'root' ] && chown root:root "${REPOSITORY}"/media_info
        [ $(stat -c "%a" "${REPOSITORY}"/media_info ) != '755' ] && chmod 0755 "${REPOSITORY}"/media_info
    fi
}

if [ -n "$1" ]; then
    run_createrepo "$1" "$2"
else
    REPOSITORY="/share/platforms/3.0/repository"
    [ ! -d "${REPOSITORY}" ] && printf '%s\n' "Directory ${REPOSITORY} does not exist. Exiting." && exit 1

    for i in i586 x86_64 SRPMS; do
        for j in main contrib non-free restricted debug_main debug_contrib debug_non-free debug_restricted; do
            for k in release updates testing; do
                run_createrepo "${REPOSITORY}/${i}/${j}/${k}"
            done
        done
    done
fi

exit 0
