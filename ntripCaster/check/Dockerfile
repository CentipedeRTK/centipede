#docker build -t jancelin/centipede:check -f Dockerfile.futur1 .
#docker run --rm --network host jancelin/centipede:check
#docker run -it --rm --entrypoint /bin/bash  jancelin/centipede:check

FROM debian:stretch-slim
MAINTAINER Julien Ancelin<julien.ancelin@inra.fr>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN echo "deb    http://http.debian.net/debian sid main " >> /etc/apt/sources.list

#install 
RUN apt-get update \
  && apt-get install -t sid -y gcc git build-essential automake checkinstall \
                               postgresql-client jq curl python-dev procps wget gpsd-clients\
  && wget -qO - https://github.com/tomojitakasu/RTKLIB/archive/v2.4.3-b34.tar.gz | tar -xvz \
  && make --directory=RTKLIB-2.4.3-b34/app/consapp/str2str/gcc \
  && make --directory=RTKLIB-2.4.3-b34/app/consapp/str2str/gcc install \
  && apt-get purge -y --auto-remove git build-essential automake checkinstall gcc
  
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

COPY test_start.sh test_start.sh
RUN chmod +x test_start.sh

ENTRYPOINT ["/bin/test_start.sh"]
CMD [" "]
