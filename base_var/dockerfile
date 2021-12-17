FROM debian:latest
LABEL "GNU Affero General Public License v3 (AGPL-3.0)"="julien.ancelin@inrae.fr"
RUN apt-get update && apt-get install -y wget git apt-utils systemd lsb-release
#install rtklib
RUN wget https://raw.githubusercontent.com/jancelin/rtkbase/dev_rtkrover/tools/install.sh
RUN find ./ -type f -iname "*.sh" -exec chmod +x {} \;
RUN sed -i -e "s/\$(logname)/root/g" ./install.sh
RUN sed -i -e "s/sudo -u root//g" ./install.sh
RUN ./install.sh --dependencies --rtklib
#install dep for ntripbrowser
RUN apt-get install -y libssl-dev libcurl4-openssl-dev python-dev
#install python package
RUN pip install --upgrade pyserial pynmea2 ntripbrowser python-telegram-bot
#for kill str2str ps aux
RUN apt-get install -y procps
#copy pybasevar
COPY pybasevar/* /home/
WORKDIR /home
RUN chmod +x ./run.sh
ENTRYPOINT [ "./run.sh" ]
