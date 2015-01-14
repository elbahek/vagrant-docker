FROM ubuntu:trusty

# update all
RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive 
RUN apt-get --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

# install support packages
RUN apt-get --assume-yes install mc bash-completion wget
RUN echo "SELECTED_EDITOR=/usr/bin/mcedit" > /root/.selected_editor

# install mysql-proxy 0.8.5
RUN apt-get --assume-yes install mysql-proxy

COPY ./*.lua /root/
RUN chmod 644 /root/*.lua
ADD ./run.sh /run.sh
RUN chmod 755 /run.sh

EXPOSE 4040

CMD ["/run.sh"]