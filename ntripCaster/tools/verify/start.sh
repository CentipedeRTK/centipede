#!/bin/bash
# script for get ECEF & llh of RTK BASES from ntripcaster mountpoint.

echo "Wait 11 seconds ...";
str2str -in ntrip://@caster.centipede.fr:2101/$MP -out tcpsvr://localhost:2102 &>/dev/null &
curl -sS --max-time 11 http://localhost:2102 | gpsdecode -j | jq -r 'select(.type == 1006) | [.x,.y,.z] | @sh' > ecef &&
var=$(cat ecef)
echo ""
echo "Centipede Mount Point: $MP"
echo "---------------------------------"
echo "ECEF"
echo "$var"
echo ""
echo "World Geodetic System 1984/ IGNF:WGS84G"
echo "Lat,Long,Height"
python ecef2llh.py $var;
echo "---------------------------------"
kill 6


