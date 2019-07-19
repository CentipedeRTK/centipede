#!/bin/bash
# script for Check RTK (emlid) BASES from ntripcaster mountpoint. ($MP or i )
exec 2>/dev/null # no-verbose (# for debug)

#caster parameters
CAST_ADD=caster.centipede.fr
CAST_PORT=2101

#database parameters
TABLE='public.antenne'      ##table
PING='ping'                 ##champ boolean
DATE='ping_date'            ##champ timestamp with time zone
ID='mp'                     ##champ Id de l'entité

LIST_A=$(psql -t --command="select mp from public.antenne order by mp;" postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME) # get Mount Point list
echo $LIST_A

for i in $LIST_A
do
  echo "__________________________________________________________________________"
  echo " >>>>>> Check "$i ": Wait 21 seconds ...";
  str2str -in ntrip://@$CAST_ADD:$CAST_PORT/$i -out tcpsvr://localhost:2102 &>/dev/null &   # get RTCM stream 
#  curl -sS --max-time 21 http://localhost:2102 | gpsdecode -j |  jq --seq -s -r .[] >RTCM3 &&         # capture and decode
  curl -sS --max-time 21 http://localhost:2102 | gpsdecode -j |  jq -R 'fromjson?' >RTCM3 &&  #resolve problem with bad json format but not display all values...

  if [ -s RTCM3 ]; then
    TYPE=STR
    #mountpoint
    #IDENTIFIER= #commune ou $MP
    FORMAT=$(jq -s -r '[(.[] |.class)] | unique | @csv' < RTCM3)  #get classe (RTCM3,....)
    FORMATD=$(jq -s -r '[(.[] |.type)] | unique | @csv' < RTCM3)  #get list of 
    CARRIER=1 #$(jq -s -r '[(.[] |.type)] | unique' < RTCM3 | jq -r 'if .[] == 1002 then 1 elif .[] == 1004 then 2 else empty end') #get L1, L1-L2, dgps
    GPS=$(jq -s -r '[(.[] |.type)] | unique | {type: .[]} | if (select(.type >=1001) | select(.type <=1004)) or (select(.type >=1071) | select(.type <=1077)) then "GPS" else empty end ' < RTCM3)
    GLO=$(jq -s -r '[(.[] |.type)] | unique | {type: .[]} | if (select(.type >=1009) | select(.type <=1012)) or (select(.type >=1081) | select(.type <=1087)) then "GLO+" else empty end ' < RTCM3)
    GAL=$(jq -s -r '[(.[] |.type)] | unique | {type: .[]} | if (select(.type >=1091) | select(.type <=1097)) then "GAL+" else empty end ' < RTCM3)
    BDS=$(jq -s -r '[(.[] |.type)] | unique | {type: .[]} | if (select(.type >=1121) | select(.type <=1127)) then "BDS+" else empty end ' < RTCM3)
    QZS=$(jq -s -r '[(.[] |.type)] | unique | {type: .[]} | if (select(.type >=1111) | select(.type <=1117)) then "QZS+" else empty end ' < RTCM3)
    SBS=$(jq -s -r '[(.[] |.type)] | unique | {type: .[]} | if (select(.type >=1101) | select(.type <=1107)) then "SBS+" else empty end ' < RTCM3)
    NAVSYS="$GLO""$GAL""$BDS""$QZS""$SBS""$GPS" #display nav system
    NETW=EUREF
    COUNTRY=FRA
    ECEF=$(jq -r 'select(.type == 1006) | [.x,.y,.z] | @sh' < RTCM3) #get Lat long alt (ECEF)
    LAT=$(python ecef2lat.py $ECEF) # transfom lat ECEF > WGS84
    LON=$(python ecef2lon.py $ECEF) # transfom lat ECEF > WGS84
    ALT=$(python ecef2alt.py $ECEF) # transfom lat ECEF > WGS84
    NMEA=0
    SOLUT=0
    GENER=sNTRIP
    COMP=none
    AUTH=N
    FEE=N
    #https://docs.emlid.com/reach/common/reachview/base-mode/ GPS+GLO+GAL+BDS+SBS
    BIT=101
    MISC=CENTIPEDE
    echo "----------  "$i "UP"
    echo $TYPE";"$i";"$i";"$FORMAT";"$FORMATD";"$CARRIER";"$NAVSYS";"$NETW";"$COUNTRY";"$LAT";"$LON";"$ALT";"$NMEA";"$SOLUT";"$GENER";"$COMP";"$AUTH";"$FEE";"$BIT";"$MISC
    
    psql --command="update $TABLE SET 
      $PING= true, 
      $DATE= LOCALTIMESTAMP(0),
      type= '$TYPE',
      format= '$FORMAT',
      formatd= '$FORMATD',
      carrier= $CARRIER,
      navsys= '$NAVSYS',
      network= '$NETW',
      country= '$COUNTRY',
      latitude= $LAT,
      longitude= $LON,
      nmea= $NMEA,
      solution= $SOLUT,
      generator= '$GENER',
      compres= '$COMP',
      auth= '$AUTH',
      fee= '$FEE',
      bit= $BIT,
      misc= '$MISC',
      altitude= $ALT
      WHERE $ID = '$i';" postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME
      kill -9 $(ps aux | grep -e str2str| awk '{ print $2 }') 
      echo "______________________________________________________________________"
  else
      echo "--------  "$i "DOWN"
      psql --command="update $TABLE SET $PING= false  where $ID = '$i';" postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME &&
      MAIL=$(psql -t --command="SELECT cont.mail FROM centipede.contact as cont LEFT JOIN public.antenne as ant ON ant.id = cont.id_antenne WHERE ant.mp = '$i' AND ant.ping_date NOTNULL;"  postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME) &&
      if [ -z "$MAIL" ]
      then
        echo "base déclarée mais non active"
      else
        echo "send mail to " $MAIL &&
        docker run --rm -e MP=$i -e MAIL="$MAIL" -v /home/sig/centipede/ntripCaster/ssmtp/ssmtp.conf:/etc/ssmtp/ssmtp.conf jancelin/centipede:ssmtp &&
        echo "mail sent to " $MAIL" !!!"
      fi
      kill -9 $(ps aux | grep -e str2str| awk '{ print $2 }') 
      echo "______________________________________________________________________"
  fi

done 

