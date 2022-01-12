import serial
import io
from decimal import *
## 00-START socat TODO
socat="socat -d -d pty,raw,echo=0 pty,raw,echo=0 &>/dev/null"
## 01-Start caster
ntripc="str2str -in serial://pts/2:115200:8:n:1:off -n 1 -b 1 -out ntripc://@:9999/ME &>/dev/null"
pid_str=0
## 02-Start a generic stream RTCM3 in
stream1="str2str -in ntrip://:@caster.centipede.fr:80/"
stream2=" -out serial://pts/1:115200:8:n:1:off &>/dev/null"
## 1-Analyse nmea from gnss ntripclient for get lon lat
ser = serial.Serial('/dev/pts/1', 115200, timeout=1)
sio = io.TextIOWrapper(io.BufferedRWPair(ser, ser))
## Defaut longitude
lon = 0.0
rlon = Decimal('-0.949')
rlat = Decimal('46.165')
rtime = '00:00:00'
## 2-Get caster sourcetable
caster='caster.centipede.fr'
port=80
###max search distance between rover & caster bases
maxdist=300
## 3-Get variables
###defaut mountpoint
mp_use = "CT"
mp_alive="CT"
##defaut Distance between rover > base
dist_r2mp = 500
###critical distance before change
mp_km_crit = 15
###hysteresis
htrs = 1
###message
message = "Defaut_Message"
