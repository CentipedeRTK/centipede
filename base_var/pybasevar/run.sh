#!/bin/bash

echo "SYSTEM: create serial /dev/pts/1 /2"
##TODO bug when socat start from pybasegnss.py, Temporarily it starts here
socat -d -d pty,raw,echo=0 pty,raw,echo=0 &>/dev/null &
sleep 3 &&
echo "SYSTEM: Start pybasevar"
echo "SYSTEM: Telegram connexion > apikey :"$APIKEY " / user id" $USERID
touch /home/basevarlog.csv
python3 /home/pybasevar.py $APIKEY $USERID
