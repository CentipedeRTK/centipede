#!/bin/bash

echo "create /dev/pts/1 /2"
##TODO bug when socat start from pybasegnss.py,
socat -d -d pty,raw,echo=0 pty,raw,echo=0 &>/dev/null & Temporarily it starts here
sleep 3 &&
echo "start pybasevar"
echo "Telegram connexion > apikey :"$APIKEY " / user id" $USERID
python3 /home/pybasevar.py $APIKEY $USERID
