#!/bin/bash
openssl rehash
/usr/sbin/cron -l 2 -f
