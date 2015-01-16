#!/bin/bash

if [ -n "$TIMEZONE" ] && [ ! -f /etc/timezone ]; then
    echo $TIMEZONE | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
fi
if [ -n "$TIMEZONE" ] && [ -f /etc/timezone ] && [ "$TIMEZONE" != $(cat /etc/timezone) ]; then
    echo $TIMEZONE | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
fi

exec mysql-proxy --plugins=proxy \
    --log-level=debug --log-file=/var/log/mysql_proxy/mysql_proxy.log \
    --proxy-backend-addresses="${VAGRANT_IP}:${MYSQL_DEFAULT_PORT}" --proxy-lua-script=/root/reporter.lua