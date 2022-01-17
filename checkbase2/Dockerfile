ARG DISTRO=debian
ARG IMAGE_VERSION=bullseye
ARG IMAGE_VARIANT=slim
FROM $DISTRO:$IMAGE_VERSION-$IMAGE_VARIANT AS Ntrip-checker2
MAINTAINER Julien Ancelin<julien.ancelin@inrae.fr>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get update \
  && apt-get install -y ssmtp postgresql-client curl libssl-dev libcurl4-openssl-dev python3-dev python3-pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/?*

RUN pip install --upgrade ntripbrowser

COPY check.sh /home/check.sh
COPY mail.sh /home/mail.sh
COPY mail_activ.sh /home/mail_activ.sh
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf
COPY browser.py /home/browser.py
RUN find /home/ -type f -iname "*.sh" -exec chmod +x {} \;

ENTRYPOINT /home/check.sh
