import io
import pynmea2
import serial
import time
import subprocess
import os
import signal
import telegram
import sys
from ntripbrowser import NtripBrowser
from multiprocessing import Process

caster='caster.centipede.fr'
port=2101
maxdist=50
#socat="socat -d -d pty,raw,echo=0 pty,raw,echo=0 &>/dev/null"
socat="socat -d -d pty,raw,echo=0 pty,raw,echo=0"
ntripc="str2str -in serial://pts/2:115200:8:n:1:off -n 1 -b 1 -out ntripc://@:9999/ME &>/dev/null"
stream1="str2str -in ntrip://:@caster.centipede.fr:2101/"
stream2=" -out serial://pts/1:115200:8:n:1:off &>/dev/null"
mp_use = "ENSG"
ser = serial.Serial('/dev/pts/1', 115200, timeout=1)
sio = io.TextIOWrapper(io.BufferedRWPair(ser, ser))
lon = 0.0
mp_km_sav = 50

## Get nearest Mountpoint
def loop_mp():
    while True:
        try:
            ##Analyse nmea from gnss ntripclient for get lon lat
            line = sio.readline()
            msg = pynmea2.parse(line)
            if msg.longitude != lon:
                latlon= msg.latitude, msg.longitude
                print(latlon,msg.timestamp)
                ##Get caster sourcetable
                browser = NtripBrowser(caster, port=port, timeout=10,
                    coordinates=(msg.latitude,msg.longitude), maxdist=maxdist )
                #print(browser.get_mountpoints())
                getmp= browser.get_mountpoints()
                filtermp = getmp['str']
                #print(m)
                ##Get list of the nearest mountpoint
                for i in filtermp:
                    mp = i["Mountpoint"]
                    di = round(i["Distance"],2)
                    print(mp,di,"km")
                ##Get nearest mountpoint
                for i, value in enumerate(filtermp):
                    if i == 0:
                        mp_use1 = value["Mountpoint"]
                        mp_use_km = value["Distance"]
                        print("You can Use: ",mp_use1,round(mp_use_km,2),"km")
                        ##Modify str2str in
                        global mp_use
                        global pid_str
                        global mp_km_sav
                        if mp_use != mp_use1: ##and round(mp_km_sav,0) > 2:
                            bashstr = stream1 + mp_use1 + stream2
                            #print(bashstr)
                            print("Move to base ",mp_use1, " !")
                            ##KILL old str2str_in
                            killstr = "kill -9 " + str(pid_str)
                            str2str = subprocess.Popen(killstr.split())
                            print("str2str is killing, old pid:", pid_str)
                            ##Running  a new str2str_in
                            mp_use = mp_use1
                            mp_km_sav = mp_use_km
                            time.sleep(3)
                            str2str = subprocess.Popen(bashstr.split())
                            pid_str = str2str.pid

                            ##Send message to Telegram if param exist
                            if len(sys.argv) >= 2:
                                api_key = str( sys.argv[1] )
                                user_id = str( sys.argv[2] )
                                #print(api_key+user_id)
                                message = "Move to base ," + str(mp_use1) +","+str(round(mp_use_km,2))+","+str(round(msg.latitude,7))+","+str(round(msg.longitude,7))+","+ str(msg.timestamp)
                                bot = telegram.Bot(token=api_key)
                                bot.send_message(chat_id=user_id, text=message)

        except serial.SerialException as e:
            #print('Device error: {}'.format(e))
            continue

        except pynmea2.ParseError as e:
            #print('Parse error: {}'.format(e))
            continue

##Open virtual ports
def socat():
    process1 = subprocess.Popen(socat.split())
    print("/dev/pts/1 & /2 created")
    time.sleep(3)

##Run str2str in and out
def str2str_out():
    ##run ntripcaster
    process2 = subprocess.Popen(ntripc.split())
    pid2 = process2.pid
    print("str2str serial 2 ntripc is runnig, pid: ",pid2)

if __name__ == '__main__':
    ##Start caster
    Process(target=str2str_out).start()
    ##Start a generic stream RTCM3 in
    bashstr = stream1+mp_use+stream2
    str2str = subprocess.Popen(bashstr.split())
    pid_str = str2str.pid
    print("str2str defaut ntripcli 2 serial is runnig, pid: ",pid_str)
    ##Run loop to check rover position and nearest base
    Process(target=loop_mp).start()
