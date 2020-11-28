#!/bin/bash

# SCRIPT_ID variable for self-update
SCRIPT_ID=3c174aaa

# check if Auto-update is enabled
if [ $(cat /etc/kiwi.config/_UPDATE) -eq 1 ]; then
    echo "Auto-update is enabled, will now check for update."
else
    echo "Auto-update is disabled, exiting."
    exit 0
fi

# Check internet connectivity
NETWORK_CHECK_URL="public.dns.iij.jp"
NETWORK_CHECK_RESPONSE="000"
if [ $(curl -I -s --connect-timeout 15 --insecure --retry 10 ${NETWORK_CHECK_URL} -w %{http_code} | tail -n1) -eq ${NETWORK_CHECK_RESPONSE} ]; then
    echo "Internet connected, continue."
else
    echo "Internet not connected, exiting."
    exit 1
fi

# Define global environment variables
APP_NAME="flydog-sdr"
CURL_ARGS="-L -s --connect-timeout 15 --insecure --retry 10"
CURRENT_VER="$(curl ${CURL_ARGS} http://${APP_NAME}:8073/VER | jq --raw-output '(.maj|tostring) + (.min|tostring)')"
REMOTE_VER="$(curl ${CURL_ARGS} --resolve raw.githubusercontent.com:443:151.101.88.133 https://raw.githubusercontent.com/flydog-sdr/FlyDog_SDR_GPS/master/Makefile | head -2 | cut -d " " -f3 | tr -d "\n")"
IMAGE_TAG="registry.cn-shanghai.aliyuncs.com/flydog-sdr/flydog-sdr:latest"
LOCAL_IMAGE_ID=$(docker inspect -f {{".Id"}} ${IMAGE_TAG})
SCRIPTS_FETCH_URL="https://codeload.github.com/flydog-sdr/customised-scripts/zip/master"

# Version comparison
if [ ${CURRENT_VER} -ne ${REMOTE_VER} ]; then
    echo "New version detected, will now fetch deployment scripts and upgrade."
else
    echo "Already the latest version, exiting."
    exit 0
fi

# Fetch deployment scripts
if [ ! -f "/tmp/customised-scripts" ];then
    curl ${CURL_ARGS} --resolve codeload.github.com:443:13.112.159.149 ${SCRIPTS_FETCH_URL} | busybox unzip - -d /tmp
    mv -f /tmp/customised-scripts-master /tmp/customised-scripts
    chmod -R 755 /tmp/customised-scripts
else
    rm -rf /tmp/customised-scripts
    curl ${CURL_ARGS} --resolve codeload.github.com:443:13.112.159.149 ${SCRIPTS_FETCH_URL} | busybox unzip - -d /tmp
    mv -f /tmp/customised-scripts-master /tmp/customised-scripts
    chmod -R 755 /tmp/customised-scripts
fi

# Execute deployment scripts
bash -c /tmp/customised-scripts/deploy.sh

# Purge previous image for saving disk space
echo "Purging all unused or dangling images, containers."
docker container prune -f
docker image prune -f

# Self-update check
if [ ${SCRIPT_ID} = $(cat self-update.sh | sed -n '4p'| cut -d "=" -f2) ]; then
    echo "Upgrade finished!"
else
    cat /tmp/customised-scripts/self-update.sh > /usr/bin/updater.sh
    echo "Upgrade finished!"
fi
rm -rf /tmp/customised-scripts
exit 0
