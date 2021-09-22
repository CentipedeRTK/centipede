#!/bin/bash
##Script for get RTK BASES rtcm3 data from ntripcaster mountpoint to postgresql
exec 2>/dev/null # no-verbose (# for debug)

##Config mail sender with .env file
SSMTP=/etc/ssmtp/ssmtp.conf
sed -i.bak 's/^rewriteDomain=.*/rewriteDomain='$REWRITEDOMAIN'/' $SSMTP
sed -i.bak 's/^AuthUser=.*/AuthUser='$AUTHUSER'/' $SSMTP
sed -i.bak 's/^AuthPass=.*/AuthPass='$AUTHPSWD'/' $SSMTP
sed -i.bak 's/^mailhub=.*/mailhub='$MAILHUB'/' $SSMTP
#cat $SSMTP

##Database parameters
TABLE='public.antenne'      ##table
TABLE2="logs.defaut"
PING='ping'                 ##champ boolean
DATE='ping_date'            ##champ timestamp with time zone
ID='mp'                     ##champ Id de l'entité

while :
  do
    ##Get all mountpoint from caster
    LIST_A=$(psql -t --command="select mp from public.antenne order by mp;" postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME) # get Mount Point list
    echo $LIST_A

    for i in $LIST_A
    do
      ##Connect to a Caster Mount Point and get Rtcm3 messages
      echo "__________________________________________________________________________"
      echo " >>>>>> Check BASE GNSS "$i ": Wait 35 seconds ...";
      str2str -in ntrip://@$CAST_ADD:$CAST_PORT/$i -out tcpsvr://localhost:2102 &>/dev/null &   # get RTCM stream
      curl -sS --http0.9 --max-time 35 http://localhost:2102 | gpsdecode -j |  jq -R 'fromjson?' >RTCM3 &&  #store data
      SIZE=`stat -c "%s" RTCM3`
      echo "RTCM3 file Size: $SIZE"
      ##Analyse RTCM3 messages
      if [ -s RTCM3 ]; then
        TYPE=STR
        FORMAT=$(jq -s -r '[(.[] |.class)] | unique | @tsv' < RTCM3)  #get classe (RTCM3,....)
        FORMATD=$(jq -s -r '[(.[] |.type)] | unique | @csv' < RTCM3)  #get list of
        CARRIER=1 #$(jq -s -r '[(.[] |.type)] | unique' < RTCM3 | jq -r 'if .[] == 1002 then 1 elif .[] == 1004 then 2 else empty end') #get L1, L1-L2, dgps
        ##GET rtcm3 type messages
        GPS_MES="contains([1001]) or contains([1002]) or contains([1003]) or contains([1004]) or contains([1071]) or contains([1072]) or contains([1073]) or contains([1074]) or contains([1075]) or contains([1076]) or contains([1077])"
        GLO_MES="contains([1009]) or contains([1010]) or contains([1011]) or contains([1012]) or contains([1081]) or contains([1082]) or contains([1083]) or contains([1084]) or contains([1085]) or contains([1086]) or contains([1087])"
        GAL_MES="contains([1091]) or contains([1092]) or contains([1093]) or contains([1094]) or contains([1095]) or contains([1096]) or contains([1097])"
        SBS_MES="contains([1101]) or contains([1102]) or contains([1103]) or contains([1104]) or contains([1105]) or contains([1106]) or contains([1107])"
        QZS_MES="contains([1111]) or contains([1112]) or contains([1113]) or contains([1114]) or contains([1115]) or contains([1116]) or contains([1117])"
        BDS_MES="contains([1121]) or contains([1122]) or contains([1123]) or contains([1124]) or contains([1125]) or contains([1126]) or contains([1127])"
        ##Get satelites systems
        GPS=$(jq -s -r '[(.[] |.type)] | unique | '"$GPS_MES"' | if . == true then "GPS" else empty end' < RTCM3)
        GLO=$(jq -s -r '[(.[] |.type)] | unique | '"$GLO_MES"' | if . == true then "GLO+" else empty end' < RTCM3)
        GAL=$(jq -s -r '[(.[] |.type)] | unique | '"$GAL_MES"' | if . == true then "GAL+" else empty end' < RTCM3)
        SBS=$(jq -s -r '[(.[] |.type)] | unique | '"$SBS_MES"' | if . == true then "SBS+" else empty end' < RTCM3)
        QZS=$(jq -s -r '[(.[] |.type)] | unique | '"$QZS_MES"' | if . == true then "QZS+" else empty end' < RTCM3)
        BDS=$(jq -s -r '[(.[] |.type)] | unique | '"$BDS_MES"' | if . == true then "BDS+" else empty end' < RTCM3)

        NAVSYS="$GLO""$GAL""$SBS""$QZS""$BDS""$GPS" #display nav system
        NETW=NONE
        #COUNTRY=FRA
        ##Get XYZ (ECEF)
        ECEFT=$(jq -r 'select(.type == 1006) | [.x,.y,.z] | @sh' < RTCM3) #test if 1006 exist
        ECEF=$(if [ -z "$ECEFT" ]
    		        then jq -r 'select(.type == 1005) | [.x,.y,.z] | @sh' < RTCM3
    		        else jq -r 'select(.type == 1006) | [.x,.y,.z] | @sh' < RTCM3
    	         fi )
      #TODO migrate to proj7.2.1 for convert to LAT LON ALT (ECEF>RGF93)
      #TODO docker run --rm -it osgeo/proj:7.2.1 bash -c 'echo "4426043.0431 -89429.2032 4576296.6490" | cs2cs EPSG:4964 +to EPSG:4171 -f %.12f -d 9'
        LAT=$(python ecef2lat.py $ECEF) # transfom lat ECEF > WGS84
        LON=$(python ecef2lon.py $ECEF) # transfom lat ECEF > WGS84
        ALT=$(python ecef2alt.py $ECEF) # transfom lat ECEF > WGS84
        NMEA=0
        SOLUT=0
        #GENER="NTRIP RTKLIB/2.4.3"
        COMP=none
        AUTH=N
        FEE=N
        BIT=101
        MISC=CENTIPEDE
        ##Get receiver and antenna informations
        REC=$(jq -s -r  '[(.[] |select (.receiver != null) | .receiver)] | unique | @tsv' < RTCM3)	# receiver type
        VER=$(jq -s -r  '[(.[] |select (.firmware != null) | .firmware)] | unique | @tsv' < RTCM3) 	# version rtkbase
        ANT=$(jq -s -r  '[(.[] |select (.desc != null) | .desc)] | unique | @tsv' < RTCM3) 		# type antenne
        SID=$(jq -s -r  '[(.[] |select (.station_id != null) | .station_id)] | unique | @tsv' < RTCM3) #station id
        GENER="NTRIP $REC $VER"

        echo "----------  "$i "UP"
        echo $TYPE";"$i";"$i";"$FORMAT";"$FORMATD";"$CARRIER";"$NAVSYS";"$NETW";"$COUNTRY";"$LAT";"$LON";"$ALT";"$NMEA";"$SOLUT";"$GENER";"$COMP";"$AUTH";"$FEE";"$BIT";"$MISC
        echo $REC";"$VER";"$ANT";"$SID

        ##Update data to database
        psql --command=" BEGIN;
          update $TABLE SET
          $PING= true,
          $DATE= LOCALTIMESTAMP(0),
          type= '$TYPE',
          format= '$FORMAT',
          formatd= '$FORMATD',
          navsys= '$NAVSYS',
          network= '$NETW',
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
          altitude= $ALT,
          receiver= '$REC',
          version= '$VER',
          antenne= '$ANT',
          station_id= $SID
          WHERE $ID = '$i';
          COMMIT;" postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME
          echo "______________________________________________________________________"
      else
        echo "--------  "$i "DOWN"
        psql --command="UPDATE $TABLE SET $PING= false  where $ID = '$i';" \
        postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME &&
        # MAIL=$(psql -t --command="SELECT cont.mail
        #         FROM centipede.contact as cont
        #         LEFT JOIN public.antenne as ant ON ant.id = cont.id_antenne
        #         WHERE ant.mp = '$i'
        #           AND ant.ping_date NOTNULL;"  \
        #       postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME)
        # export MAIL=$MAIL
        # export MP=$i
        # /home/mail.sh
        #echo "mail base DOWN sent to " $MAIL" !!!"
        echo "______________________________________________________________________"
      fi
      ##destroy str2str pipe
      kill -9 $(ps aux | grep -e str2str| awk '{ print $2 }')
      rm RTCM3
    done
  done
exit 0
