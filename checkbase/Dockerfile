ARG DISTRO=debian
ARG IMAGE_VERSION=bullseye
ARG IMAGE_VARIANT=slim
FROM $DISTRO:$IMAGE_VERSION-$IMAGE_VARIANT AS Ntrip-checker
MAINTAINER Julien Ancelin<julien.ancelin@inrae.fr>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN echo "deb    http://http.debian.net/debian sid main " >> /etc/apt/sources.list

#install
RUN apt-get update \
  && apt-get install -t sid -y gcc git build-essential automake checkinstall ssmtp\
                               postgresql-client jq curl python-dev procps wget gpsd-clients\
  && wget -qO - https://github.com/tomojitakasu/RTKLIB/archive/v2.4.3-b34.tar.gz | tar -xvz \
  && make --directory=RTKLIB-2.4.3-b34/app/consapp/str2str/gcc \
  && make --directory=RTKLIB-2.4.3-b34/app/consapp/str2str/gcc install \
  && rm -rf RTKLIB-2.4.3-b34/ \
  && apt-get purge -y --auto-remove git build-essential automake checkinstall gcc

#deploy check_centipede
WORKDIR /bin
#TODO use proj7 for convert ecef to lat lon elv
COPY ecef2lat.py ecef2lat.py
COPY ecef2lon.py ecef2lon.py
COPY ecef2alt.py ecef2alt.py
RUN chmod +x ecef2lat.py
RUN chmod +x ecef2lon.py
RUN chmod +x ecef2alt.py
#sent mail
COPY mail.sh /home/mail.sh
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf
RUN find /home/ -type f -iname "*.sh" -exec chmod +x {} \;

COPY start.sh start.sh
RUN chmod +x start.sh

ENTRYPOINT /bin/start.sh
