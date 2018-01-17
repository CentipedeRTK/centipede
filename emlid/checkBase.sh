#!/bin/sh 
## script write by Julien ANCELIN/INRA julien.ancelin@inra.fr
##This script ping website and update résultat in database 

RTCM = jancelin.ddns.net    ##DNS ou IP
PORT = 9000                 ##Port de diffusion
CONTAINER = sig_postgis_1   ##container postgis
BASE = demo                 ##base de données
TABLE = rtk.antenne         ##table
PING = ping                 ##champ boolean
DATE = ping_date            ##champ timestamp with time zone
ID = id                     ##Id de l'entité

  if nc -z -w2 $RTCM $PORT ; then
      echo OK
      docker exec -d $CONTAINER su postgres -c "psql $BASE -c 'update $TABLE SET $PING= true, $DATE= LOCALTIMESTAMP(0)  where $ID = 7;'"
  else
      echo DOWN
      docker exec -d $CONTAINER su postgres -c "psql $BASE -c 'update $TABLE SET $PING= false  where $ID = 7;'"
