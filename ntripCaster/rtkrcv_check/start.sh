pkill rtkrcv && rtkrcv -s -p 5000 -m 5001 -o /home/jancelin/centipede/ntripCaster/rtkrcv_check/rtkrcv.conf


rtkrcv -s -o /home/jancelin/centipede/ntripCaster/rtkrcv_check/rtkrcv.conf




cd /centipede/ntripCaster/rtkrcv_check
wget -qO - https://github.com/tomojitakasu/RTKLIB/archive/v2.4.3-b34.tar.gz | tar -xvz

##bug ntripc: https://github.com/tomojitakasu/RTKLIB/issues/569
#Replace in rtkrcv.c the follow string #define ISTOPT "0:off,1:serial,2:file,3:tcpsvr,4:tcpcli,7:ntripcli,8:ftp,9:http"
#to #define ISTOPT "0:off,1:serial,2:file,3:tcpsvr,4:tcpcli,6:ntripcli,7:ftp,8:http"
nano /home/jancelin/centipede/ntripCaster/rtkrcv_check/RTKLIB-2.4.3-b34/app/consapp/rtkrcv/rtkrcv.c

sudo make --directory=RTKLIB-2.4.3-b34/app/consapp/rtkrcv/gcc
sudo make --directory=RTKLIB-2.4.3-b34/app/consapp/rtkrcv/gcc install


sudo make --directory=RTKLIB-2.4.3-b34/app/consapp/str2str/gcc
sudo make --directory=RTKLIB-2.4.3-b34/app/consapp/str2str/gcc install



#https://github.com/raess1/rtkrcv_parser/blob/master/status.py
