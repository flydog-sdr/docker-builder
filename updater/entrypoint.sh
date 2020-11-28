#!/bin/bash

# Bind IP Address of d.sdrotg.com
echo "1.0.0.1 d.sdrotg.com" >> /etc/hosts

# Start crontab
/usr/sbin/cron -l 2 -f
