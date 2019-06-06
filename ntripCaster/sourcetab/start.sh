#!/bin/bash
# script to create sourtab entry from RTK BASES from ntripcaster mountpoint.

echo "Wait 11 seconds ...";
str2str -in ntrip://@caster.centipede.fr:2101/$MP -out tcpsvr://localhost:2102 &>/dev/null &
curl -sS --max-time 11 http://localhost:2102 | gpsdecode -j |  jq -s -r .[] >RTCM3 &&

TYPE=STR
#mountpoint
#IDENTIFIER= #commune ou $MP
FORMAT=$(jq -s -r '[(.[] |.class)] | unique | @csv' < RTCM3)
FORMATD=$(jq -s -r '[(.[] |.type)] | unique | @csv' < RTCM3)
CARRIER=1
NAVSYS=GPS+GLO+GAL+BDS+SBS
NETW=EUREF
COUNTRY=FRA
ECEF=$(jq -r 'select(.type == 1006) | [.x,.y,.z] | @sh' < RTCM3)
#!!!!!penser dans dockerfile    faire un:  chmod +x ecef2ll.py 
LL=$(python ecef2ll.py $ECEF)
NMEA=0
SOLUT=0
GENER=sNTRIP
COMP=none
AUTH=N
FEE=N
#https://docs.emlid.com/reach/common/reachview/base-mode/ GPS+GLO+GAL+BDS+SBS
BIT=101
MISC=CENTIPEDE


echo $TYPE";"$MP";"$MP";"$FORMAT";"$FORMATD";"$CARRIER";"$NAVSYS";"$NETW";"$COUNTRY";"$LL";"$NMEA";"$SOLUT";"$GENER";"$COMP";"$AUTH";"$FEE";"$BIT";"$MISC
kill 6
