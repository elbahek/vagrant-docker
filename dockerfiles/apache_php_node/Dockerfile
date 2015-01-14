FROM tutum/apache-php

EXPOSE 80

# update all
RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive 
RUN apt-get --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# install support packages
RUN apt-get --assume-yes install mc bash-completion wget
RUN echo "SELECTED_EDITOR=/usr/bin/mcedit" > /root/.selected_editor

# install additional apache modules
RUN apt-get --assume-yes install php5-dev php5-intl php5-json php5-mcrypt php5-memcached php5-sasl php5-sqlite php5-xdebug php5-xmlrpc php5-xsl
RUN a2enmod rewrite

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get --assume-yes install nodejs
RUN npm install -g gulp grunt-cli bower

# swap apache user
RUN groupadd --non-unique --gid 1000 developer
RUN useradd --non-unique --uid 1000 --gid 1000 --shell /bin/bash developer

# configure
RUN rm -rf /app /run.sh
ADD ./run.sh /run.sh
RUN chmod 755 /run.sh
COPY ./php.ini /etc/php5/apache2/php.ini
RUN chmod 644 /etc/php5/apache2/php.ini
COPY ./xdebug-settings.ini /etc/php5/apache2/conf.d/21-xdebug-settings.ini
RUN chmod 644 /etc/php5/apache2/conf.d/21-*-settings.ini