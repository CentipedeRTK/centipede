import io
import serial
import pynmea2
import time
import subprocess
import os
import signal
import telegram
import sys
from ntripbrowser import NtripBrowser
from multiprocessing import Process

import config

## 00-START socat
## TODO Open virtual ports, BUG don't run in background, use run.sh.
def socat():
 process1 = subprocess.Popen(config.socat.split())
 print("/dev/pts/1 & /2 created")
 time.sleep(3)

## 01-START caster
def str2str_out():
    ##run ntripcaster
    process2 = subprocess.Popen(config.ntripc.split())
    pid2 = process2.pid
    print("str2str serial 2 ntripc is runnig, pid: ",pid2)

## 03-START loop to check rover position and nearest base
def loop_mp():
    while True:
        try:
            ## 3-Get variables
            #global mp_use
            #global mp_km_crit
            #global dist_r2mp
            ## 4-Get str2str in pid
            global pid_str
            ## 1-Analyse nmea from gnss ntripclient for get lon lat
            ##TODO after x min reset parameters
            line = config.sio.readline()
            msg = pynmea2.parse(line)
            ## Verify is it a fake data.
            if msg.longitude != config.lon:
                ## LOG coordinate from Rover
                latlon= msg.latitude, msg.longitude
                print("ROVER: ",latlon,msg.timestamp)
                ## 2-Get caster sourcetable
                browser = NtripBrowser(config.caster, port=config.port, timeout=10,
                    coordinates=(msg.latitude,msg.longitude), maxdist=config.maxdist )
                getmp= browser.get_mountpoints()
                filtermp = getmp['str']
                ## LOG Watch all nearests mountpoints
                # for i in filtermp:
                #     mp = i["Mountpoint"]
                #     di = round(i["Distance"],2)
                #     car = i["Carrier"]
                #     print(mp,di,"km; Carrier:", car)
                ## Filter carrier L1-L2
                filtermp1 = [m for m in filtermp if int(m['Carrier'])>=2]
                ## Verify distance between rover and mountpoint used.
                filter_r2mp = [m for m in filtermp if m['Mountpoint']==config.mp_use]
                for r in filter_r2mp:
                    config.dist_r2mp = r["Distance"]
                ## Get nearest mountpoint
                for i, value in enumerate(filtermp1):
                    ## Get first row
                    if i == 0 :
                        ## LOG Nearest base available
                        mp_use1 = value["Mountpoint"]
                        mp_use_km = value["Distance"]
                        mp_Carrier = value["Carrier"]
                        print("CASTER: Nearest base is ",mp_use1,round(mp_use_km,2),"km; Carrier:",mp_Carrier)
                        print("CASTER: Distance between Rover & connected base ",config.mp_use,round(config.dist_r2mp,2),"km")
                        ## Check if it is necessary to change the base
                        if config.mp_use != mp_use1:  #and round(float(mp_use_km),0) > mp_km_crit:
                            ## Build new str2str_in command
                            bashstr = config.stream1 + mp_use1 + config.stream2
                            ## LOG Move to base
                            print("CASTER: Move to base ",mp_use1, " !")
                            ## KILL old str2str_in
                            killstr = "kill -9 " + str(pid_str)
                            str2str = subprocess.Popen(killstr.split())
                            print("str2str is killing, old pid:", pid_str)
                            ## Upd variables & Running a new str2str_in service
                            config.mp_use = mp_use1
                            time.sleep(3)
                            str2str = subprocess.Popen(bashstr.split())
                            pid_str = str2str.pid
                            ##Send message to Telegram if param exist
                            if len(sys.argv) >= 2:
                                api_key = str( sys.argv[1] )
                                user_id = str( sys.argv[2] )
                                message = "Move to base ," + str(mp_use1) +","+str(round(mp_use_km,2))+","+str(round(msg.latitude,7))+","+str(round(msg.longitude,7))+","+ str(msg.timestamp)
                                bot = telegram.Bot(token=api_key)
                                bot.send_message(chat_id=user_id, text=message)
                        if config.mp_use == mp_use1:
                            print("CASTER: Already connected to ",mp_use1)
        except serial.SerialException as e:
            #print('Device error: {}'.format(e))
            continue
        except pynmea2.ParseError as e:
            #print('Parse error: {}'.format(e))
            continue

if __name__ == '__main__':
    ## 00-START socat
    ## TODO
    ## 01-START caster
    Process(target=str2str_out).start()
    ## 02-START a generic stream RTCM3 in
    bashstr = config.stream1+config.mp_use+config.stream2
    str2str = subprocess.Popen(bashstr.split())
    ## 4-Get str2str in pid
    pid_str = str2str.pid
    print("str2str defaut ntripcli 2 serial is runnig, pid: ",pid_str)
    ## 03-START loop to check rover position and nearest base
    Process(target=loop_mp).start()
