#!/bin/sh 

#docker run --rm --network host  jancelin/centipede:check 

docker run --rm --network host -e DB_USER=centipede -e DB_PSW=centipede -e DB_NAME=centipede -e DB_IP=localhost jancelin/centipede:check


