FROM tutum/mysql

# update all
RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive 
RUN apt-get --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# install support packages
RUN apt-get --assume-yes install mc bash-completion wget
RUN echo "SELECTED_EDITOR=/usr/bin/mcedit" > /root/.selected_editor

RUN rm /run.sh
ADD ./run.sh /run.sh
RUN chmod 755 /run.sh