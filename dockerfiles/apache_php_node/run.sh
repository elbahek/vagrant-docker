#!/bin/bash

if [ -n "$TIMEZONE" ] && [ ! -f /etc/timezone ]; then
    echo $TIMEZONE | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
fi
if [ -n "$TIMEZONE" ] && [ -f /etc/timezone ] && [ "$TIMEZONE" != $(cat /etc/timezone) ]; then
    echo $TIMEZONE | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
fi

sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER='$RUN_USER_NAME'/' /etc/apache2/envvars
sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP='$RUN_USER_NAME'/' /etc/apache2/envvars

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
