#docker build -t jancelin/centipede:check_2 -f Dockerfile.futur1 .
#docker run --rm --network host jancelin/centipede:check_2

FROM debian:stretch-slim
MAINTAINER Julien Ancelin<julien.ancelin@inra.fr>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN echo "deb    http://http.debian.net/debian sid main " >> /etc/apt/sources.list

#install 
RUN apt-get update \
  && apt-get install -t sid -y gcc git build-essential automake checkinstall scons \
                               postgresql-client jq curl python-dev procps\
  && git clone -b rtklib_2.4.3 https://github.com/tomojitakasu/RTKLIB.git \
  && cd /RTKLIB/app \
  && make all \
  && make install \
  && cp /RTKLIB/app/str2str/gcc/str2str /bin \
  && make clean \
  && cd /bin \
  && git clone -b master https://gitlab.com/gpsd/gpsd \
  && cd /bin/gpsd \
  && scons && scons check && scons udev-install \
  && apt-get purge -y --auto-remove git build-essential automake checkinstall gcc scons
  
#deploy check_centipede
WORKDIR /bin
COPY ecef2lat.py ecef2lat.py
COPY ecef2lon.py ecef2lon.py
COPY ecef2alt.py ecef2alt.py
RUN chmod +x ecef2lat.py
RUN chmod +x ecef2lon.py
RUN chmod +x ecef2alt.py
ENV DB_USER centipede
ENV DB_PSW centipede
ENV DB_NAME centipede
ENV DB_IP localhost
COPY start.sh start.sh
RUN chmod +x start.sh

ENTRYPOINT ["/bin/start.sh"]
CMD [" "]
