#!/bin/bash
TOKEN="${TOKEN}"
sha_hash=$(curl --user ${TOKEN}: -POST -F "file_store[file]=@$@" http://file-store.rosalinux.ru/api/v1/upload --connect-timeout 5 --retry 5)
sha_sum=$(echo $sha_hash | grep -o -E -e "[0-9a-f]{40}")
download="https://file-store.rosalinux.ru/api/v1/file_stores/${sha_sum}"
echo $download
# ROSA_2021.1_SERVER_${ARCH}_${BUILD_ID}.iso
echo -e "PRODUCT: AARCH64 ${JOB_NAME}\nNODE: ${NODE_NAME}\nRESULT: ${download} " | /usr/bin/telegram_send.py
