#!/bin/sh

REPO=${REPOSITORY:-"/share/platforms/cooker/repository"}

for i in i686 x86_64 aarch64 armv7hl SRPMS; do
    for j in main contrib non-free restricted debug_main debug_contrib debug_non-free debug_restricted; do
	for k in release updates testing; do
	    printf '%s\n' "Starting regenerating repodata in ${REPO}/${i}/${j}/${k}"
		if [ ! -e "${REPO}"/"${i}"/"${j}"/"${k}"/repodata ]; then
			printf '%s\n' "Regenerating repodata from scratch in ${REPO}/${i}/${j}/${k}"
			mkdir -p "${REPO}"/"${i}"/"${j}"/"${k}"/repodata
			chown root:root ${REPO}/${i}/${j}/${k}/repodata
			chmod 0755 ${REPO}/${i}/${j}/${k}/repodata
			createrepo_c --no-database --workers=10 --simple-md-filenames --general-compress-type=xz --ignore-lock "${REPO}"/"${i}"/"${j}"/"${k}"
			rc=$?
		else
			printf '%s\n' "Regenerating and updating repodata from scratch in ${REPO}/${i}/${j}/${k}"
			createrepo_c --no-database --workers=10 --simple-md-filenames --general-compress-type=xz --update "${REPO}"/"${i}"/"${j}"/"${k}"
			rc=$?
		fi
	    if [ "${rc}" != '0' ]; then
		printf '%s\n' "Failed regenerating repodata in ${REPO}/${i}/${j}/${k}"
	    else
		printf '%s\n' "Fnished regenerating repodata in ${REPO}/${i}/${j}/${k}"
	    fi
	    chown root:root ${REPO}/${i}/${j}/${k}/*
	    chmod 0666 ${REPO}/${i}/${j}/${k}/*
	done
    done
done
