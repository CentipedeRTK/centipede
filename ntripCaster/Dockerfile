FROM debian:stretch
RUN apt-get update
RUN apt-get -y install  wget unzip  gcc cmake
RUN wget --no-check-certificate -P ./ https://github.com/nunojpg/ntripcaster/archive/master.zip
RUN unzip ./master.zip
WORKDIR ./ntripcaster-master

RUN ./configure
RUN make
RUN make install

ADD sourcetable.dat /usr/local/ntripcaster/
ADD sourcetable.dat /usr/local/ntripcaster/conf/
ADD ntripcaster.conf /usr/local/ntripcaster/

CMD /usr/local/ntripcaster/bin/ntripcaster
