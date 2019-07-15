#docker build -t jancelin/centipede:check .
#docker run --rm --network host jancelin/centipede:check

FROM swiftnav/rtklib:2.4.2_p13

RUN apt-get update
RUN apt-get install -y gpsd-clients jq curl nano
RUN apt-get update
RUN apt-get install -y postgresql-client
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
