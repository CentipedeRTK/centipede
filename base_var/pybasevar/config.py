import serial
import io
## 00-START socat TODO
socat="socat -d -d pty,raw,echo=0 pty,raw,echo=0 &>/dev/null"
## 01-Start caster
ntripc="str2str -in serial://pts/2:115200:8:n:1:off -n 1 -b 1 -out ntripc://@:9999/ME &>/dev/null"
## 02-Start a generic stream RTCM3 in
stream1="str2str -in ntrip://:@caster.centipede.fr:2101/"
stream2=" -out serial://pts/1:115200:8:n:1:off &>/dev/null"
## 1-Analyse nmea from gnss ntripclient for get lon lat
ser = serial.Serial('/dev/pts/1', 115200, timeout=1)
sio = io.TextIOWrapper(io.BufferedRWPair(ser, ser))
## Defaut longitude
lon = 0.0
## 2-Get caster sourcetable
caster='caster.centipede.fr'
port=2101
###max search distance between rover & caster bases
maxdist=300
## 3-Get variables
###defaut mountpoint
mp_use = "ENSG"
##defaut Distance between rover > base
dist_r2mp = 150
###critical distance before change
mp_km_crit = 20
