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

    if [ -e "${REPOSITORY}"/repodata/repomd.xml ]; then
        OLDSUM=$(sha1sum "${REPOSITORY}/repodata/repomd.xml" |cut -d' ' -f1)
    else
        OLDSUM=none
    fi

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
        createrepo_c --no-database --workers=10 --general-compress-type=xz --update --recycle-pkglist "${REPOSITORY}"
        rc=$?
        if [ "${rc}" != '0' ]; then
            printf '%s\n' "Failed updating repodata in ${REPOSITORY}, trying regeneration from scratch"
            run_createrepo "${REPOSITORY}" "regenerate"
            return
        fi
    fi

    if [ -e "${REPOSITORY}"/repodata/repomd.xml ]; then
        NEWSUM=$(sha1sum "${REPOSITORY}/repodata/repomd.xml" |cut -d' ' -f1)
    else
        NEWSUM=none
    fi
    if [ "$OLDSUM" = "$NEWSUM" ]; then
        if [ "$NEWSUM" = "none" ]; then
            printf '%s\n' "repodata doesn't seem to exist, this shouldn't happen"
        else
            printf '%s\n' "createrepo claimed to be successful, but apparently didn't do anything - retrying"
            run_createrepo "${REPOSITORY}" "regenerate"
            return
        fi
    else
        printf 'repomd.xml sha1sum changed from %s to %s\n' "$OLDSUM" "$NEWSUM"
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
