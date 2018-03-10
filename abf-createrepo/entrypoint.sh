#!/bin/bash
createrepo_c --no-database --update --workers=10 --simple-md-filenames --general-compress-type=xz /share/platforms/cooker/repository/x86_64/main/release/
createrepo_c --no-database --update --workers=10 --simple-md-filenames --general-compress-type=xz /share/platforms/cooker/repository/x86_64/contrib/release/
createrepo_c --no-database --update --workers=10 --simple-md-filenames --general-compress-type=xz /share/platforms/cooker/repository/aarch64/main/release/
createrepo_c --no-database --update --workers=10 --simple-md-filenames --general-compress-type=xz /share/platforms/cooker/repository/aarch64/contrib/release/
