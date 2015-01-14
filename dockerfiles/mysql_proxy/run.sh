#!/bin/bash

if [ -n "$TIMEZONE" ] && [ ! -f /etc/timezone ]; then
    echo $TIMEZONE | tee /etc/timezone
fi
if [ -n "$TIMEZONE" ] && [ -f /etc/timezone ] && [ "$TIMEZONE" != $(cat /etc/timezone) ]; then
    echo $TIMEZONE | tee /etc/timezone
fi

#exec mysql-proxy --keepalive --daemon --plugins=proxy \
#    --log-level=debug --log-file=/var/log/mysql_proxy/mysql_proxy.log \
#    --proxy-backend-addresses=172.16.1.10:$MYSQL_DEFAULT_PORT --proxy-lua-script=/root/reporter.lua