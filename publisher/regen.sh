#!/bin/bash
if [ -z "$1" ]
   then
   /usr/bin/docker run --rm -v /home/abf-downloads:/share/platforms openmandriva/createrepo /share/platforms/cooker/repository/i686/main/release/ regenerate
   /usr/bin/docker run --rm -v /home/abf-downloads:/share/platforms openmandriva/createrepo /share/platforms/cooker/repository/armv7hl/main/release/ regenerate
   /usr/bin/docker run --rm -v /home/abf-downloads:/share/platforms openmandriva/createrepo /share/platforms/cooker/repository/x86_64/main/release/ regenerate
   /usr/bin/docker run --rm -v /home/abf-downloads:/share/platforms openmandriva/createrepo /share/platforms/cooker/repository/aarch64/main/release/ regenerate
else
   /usr/bin/docker run --rm -v /home/abf-downloads:/share/platforms openmandriva/createrepo /share/platforms/cooker/repository/$1/main/release/ regenerate
fi
