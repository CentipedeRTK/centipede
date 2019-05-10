#docker run --rm -e MP=CT jancelin/centipede:mp2llh

FROM swiftnav/rtklib:2.4.2_p13

RUN apt-get update
RUN apt-get install -y gpsd-clients jq curl nano
WORKDIR /bin
COPY ecef2llh.py ecef2llh.py
COPY start.sh start.sh
RUN chmod +x start.sh
RUN chmod +x ecef2llh.py
ENV MP CT
ENTRYPOINT ["/bin/start.sh"]
CMD [" "]
