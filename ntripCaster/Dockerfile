FROM debian:stretch
RUN apt-get update
RUN apt-get -y install  wget unzip  gcc cmake
RUN wget --no-check-certificate -P ./ https://github.com/jancelin/ntripcaster/archive/master.zip
RUN unzip ./master.zip
WORKDIR ./ntripcaster-master
RUN ./configure
RUN make
RUN make install
WORKDIR /usr/local/ntripcaster
RUN rm ./conf/*
ADD sourcetable.dat ./conf
ADD ntripcaster.conf ./conf
ADD mountpos.conf ./conf
RUN chown -R root:staff ./
CMD /usr/local/ntripcaster/bin/ntripcaster
