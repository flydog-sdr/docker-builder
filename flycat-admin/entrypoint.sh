#!/bin/bash

mkdir -p /data
if [ ! -f "/data/config.json" ];then
    echo '{"server_settings":{"host":"0.0.0.0","port":3708},"flycat_settings":{"preference":"/data/pref.json"}}' > /data/config.json
fi

/usr/bin/admin -config /data/config.json
