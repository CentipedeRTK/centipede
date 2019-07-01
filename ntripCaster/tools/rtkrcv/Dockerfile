#docker run -it  --entrypoint /bin/bash --rm -e MP=LIENSS jancelin/centipede:rtklib
#sh entrypoint.sh

FROM debian:stretch
MAINTAINER Julien Ancelin<julien.ancelin@inra.fr>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl

RUN echo "deb    http://http.debian.net/debian sid main " >> /etc/apt/sources.list
RUN apt-get update;
RUN apt-get install -t sid -y git build-essential automake checkinstall
RUN git clone https://github.com/tomojitakasu/RTKLIB.git

WORKDIR /RTKLIB/app

RUN sh makeall.sh
RUN chmod +x rtkrcv/gcc/rtk*.sh

WORKDIR /RTKLIB/app/rtkrcv/gcc
COPY rtkrcv.conf rtkrcv.conf
ENV MP CT

#./rtkrcv -s -o rtkrcv.conf

COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

#ENTRYPOINT ["/RTKLIB/app/rtkrcv/gcc/entrypoint.sh"]
#ENTRYPOINT ["/bin/bash"]
CMD ["/RTKLIB/app/rtkrcv/gcc/entrypoint.sh"]
