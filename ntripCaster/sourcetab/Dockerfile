#docker run --rm -e MP=CT jancelin/centipede:sourcetab

FROM swiftnav/rtklib:2.4.2_p13

RUN apt-get update
RUN apt-get install -y gpsd-clients jq curl nano
WORKDIR /bin
COPY ecef2ll.py ecef2ll.py
COPY start.sh start.sh
RUN chmod +x start.sh
RUN chmod +x ecef2ll.py
ENV MP CT
ENTRYPOINT ["/bin/start.sh"]
CMD [" "]
