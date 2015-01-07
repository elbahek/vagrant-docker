FROM tutum/apache-php

# update all
RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive 
RUN apt-get --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# install support packages
RUN apt-get --assume-yes install mc bash-completion wget
RUN echo "SELECTED_EDITOR=/usr/bin/mcedit" > /root/.selected_editor

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
#COPY ./php.ini /etc/php5/apache2/php.ini
#RUN chmod 644 /etc/php5/apache2/php.ini