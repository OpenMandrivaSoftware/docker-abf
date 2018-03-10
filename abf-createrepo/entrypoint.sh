#!/bin/sh

REPO=${$1:-"/share/platforms/cooker/repository"}

for i in i686 x86_64 aarch64 armv7hl SRPMS; do
    for j in main contrib non-free restricted debug_main debug_contrib debug_non-free debug_restricted; do
	for k in release updates testing; do
	    printf '%s\n' "Regenerating repodata in ${REPO}/${i}/${j}/${k}"
	    createrepo_c --no-database --update --workers=10 --simple-md-filenames --general-compress-type=xz --update "${REPO}"/repository/"${i}"/"${j}"/"${k}"
	    rc=$?
	    if [ "${rc}" != '0' ]; then
		printf '%s\n' "Failed regenerating repodata in ${REPO}/${i}/${j}/${k}"
	    else
		printf '%s\n' "Fnished regenerating repodata in ${REPO}/${i}/${j}/${k}"
	    fi
	done
    done
done
