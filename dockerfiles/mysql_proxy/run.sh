#!/bin/bash

exec mysql-proxy --plugins=proxy \
    --log-level=debug --log-file=/var/log/mysql_proxy/mysql_proxy.log \
    --proxy-backend-addresses="${VAGRANT_IP}:${MYSQL_DEFAULT_PORT}" --proxy-lua-script=/root/reporter.lua