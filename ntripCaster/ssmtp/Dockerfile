#docker build -t jancelin/centipede:ssmtp .
#docker run --rm -v ${PWD}/ssmtp.conf:/etc/ssmtp/ssmtp.conf jancelin/centipede:ssmtp
# docker run -it --rm  --entrypoint /bin/bash jancelin/centipede:ssmtp


FROM debian:stretch-slim
MAINTAINER Julien Ancelin<julien.ancelin@inra.fr>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get update \
  && apt-get install -y ssmtp  \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/?*

COPY mail.sh /home/mail.sh
RUN chmod +x /home/mail.sh
ENV MP TEST
ENV MAIL contact@centipede.fr
CMD /home/mail.sh
