#!/bin/bash

if [ -n "$TIMEZONE" ] && [ ! -f /etc/timezone ]; then
    echo $TIMEZONE | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
fi
if [ -n "$TIMEZONE" ] && [ -f /etc/timezone ] && [ "$TIMEZONE" != $(cat /etc/timezone) ]; then
    echo $TIMEZONE | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
fi

sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER='$RUN_USER_NAME'/' /etc/apache2/envvars
sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP='$RUN_USER_NAME'/' /etc/apache2/envvars

if [ -f /etc/php5/apache2/conf.d/21-xdebug-settings.ini ]; then
    echo "xdebug.remote_host=${DEVELOPER_IP}" >> /etc/php5/apache2/conf.d/21-xdebug-settings.ini
fi

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
