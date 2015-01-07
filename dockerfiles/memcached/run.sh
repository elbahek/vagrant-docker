#!/bin/bash

if [ -n "$TIMEZONE" ] && [ ! -f /etc/timezone ]; then
    echo $TIMEZONE | tee /etc/timezone
fi
if [ -n "$TIMEZONE" ] && [ -f /etc/timezone ] && [ "$TIMEZONE" != $(cat /etc/timezone) ]; then
    echo $TIMEZONE | tee /etc/timezone
fi

#create admin account to memcached using SASL
if [ ! -f /.memcached_admin_created ]; then
    /create_memcached_admin_user.sh
fi

memcached -u root -S  -l 0.0.0.0