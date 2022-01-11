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
from datetime import datetime
import config

## 00-START socat
## TODO Open virtual ports, BUG don't run in background, use run.sh.
# def socat():
#  process1 = subprocess.Popen(config.socat.split())
#  print("/dev/pts/1 & /2 created")
#  time.sleep(3)

## 01-START caster
def str2str_out():
    ##run ntripcaster
    process2 = subprocess.Popen(config.ntripc.split())
    pid2 = process2.pid
    print("STR2STR: serial 2 ntripc is runnig, pid: ",pid2)

def main():
    ## 00-START socat
    ## TODO
    ## 01-START caster
    Process(target=str2str_out).start()
    ## 02-START a generic stream RTCM3 in
    bashstr = config.stream1+config.mp_use+config.stream2
    str2str = subprocess.Popen(bashstr.split())
    ## 4-Get str2str in pid
    config.pid_str = str2str.pid
    print("STR2STR: Defaut ntripcli 2 serial is runnig, pid: ",config.pid_str)
    ## 03-START loop to check rover position and nearest base
    Process(target=loop_mp).start()


def telegrambot():
    if len(sys.argv) >= 2:
        api_key = str( sys.argv[1] )
        user_id = str( sys.argv[2] )
        bot = telegram.Bot(token=api_key)
        bot.send_message(chat_id=user_id, text=config.message)

def logging():
    ##log in file
    presentday = datetime.now()
    file = open("basevarlog.txt", "a")
    file.write(config.message + ","+ presentday.strftime('%d-%m-%Y') +'\n')
    file.close

def movetobase():
    ## Build new str2str_in command
    bashstr = config.stream1 + mp_use1 + config.stream2
    ## LOG Move to base
    print("CASTER: Move to base ",mp_use1, " !")
    ## KILL old str2str_in
    killstr = "kill -9 " + str(config.pid_str)
    str2str = subprocess.Popen(killstr.split())
    print("STR2STR: KILL, old pid:", config.pid_str)
    ## Upd variables & Running a new str2str_in service
    config.mp_use = mp_use1
    time.sleep(3)
    str2str = subprocess.Popen(bashstr.split())
    config.pid_str = str2str.pid
    ##Metadata
    config.message = ("Move to base ," + str(mp_use1) +","+
    str(round(mp_use1_km,2))+","+str(round(msg.latitude,7))+","+
    str(round(msg.longitude,7))+","+ str(msg.timestamp))
    ##Log data in file
    logging()
    ##Send message to Telegram if param exist
    telegrambot()

## 03-START loop to check rover position and nearest base
def loop_mp():
    while True:
        try:
            global mp_use1
            global mp_use1_km
            global msg
            ## 1-Analyse nmea from gnss ntripclient for get lon lat
            ##TODO after x min reset parameters
            line = config.sio.readline()
            msg = pynmea2.parse(line)
            ## Exclude bad longitude
            if msg.longitude != config.lon:
                ## LOG coordinate from Rover
                latlon= msg.latitude, msg.longitude
                print("ROVER: ",latlon,msg.timestamp)
                ## 2-Get caster sourcetable
                browser = (NtripBrowser(config.caster, port=config.port,
                timeout=10,coordinates=(msg.latitude,msg.longitude),
                maxdist=config.maxdist ))
                getmp= browser.get_mountpoints()
                flt = getmp['str']
                ## LOG Watch all nearests mountpoints
                # for i in flt:
                #     mp = i["Mountpoint"]
                #     di = round(i["Distance"],2)
                #     car = i["Carrier"]
                #     print(mp,di,"km; Carrier:", car)
                # Purge list
                flt1 = []
                ## filter carrier L1-L2
                flt1 = [m for m in flt if int(m['Carrier'])>=2]
                ## Value on connected base
                flt_r2mp = [m for m in flt if m['Mountpoint']==config.mp_use]
                ## GET distance between rover and mountpoint used.
                for r in flt_r2mp:
                    config.dist_r2mp = r["Distance"]
                    config.mp_alive = r['Mountpoint']
                ## GET nearest mountpoint
                for i, value in enumerate(flt1):
                    ## Get first row
                    if i == 0 :
                        ## LOG Nearest base available
                        mp_use1 = value["Mountpoint"]
                        mp_use1_km = value["Distance"]
                        mp_Carrier = value["Carrier"]
                        print(
                            "INFO: Nearest base is ",mp_use1,
                            round(mp_use1_km,2),"km; Carrier:",mp_Carrier)
                        print(
                            "INFO: Distance between Rover & connected base ",
                            config.mp_use,round(config.dist_r2mp,2),"km")
                        ## Check if it is necessary to change the base
                        ## Base Alive?
                        if config.mp_use == config.mp_alive:
                            print("INFO: Base",config.mp_alive," alive")
                            ## nearest Base is different?
                            if config.mp_use != mp_use1:
                                ## Check Critical distance before change ?
                                if config.dist_r2mp > config.mp_km_crit:
                                    ##Hysteresis(htrs)
                                    crithtrs = config.mp_km_crit + config.htrs
                                    if config.dist_r2mp < crithtrs:
                                        print(
                                            "INFO: Hysteresis running: "
                                            ,crithtrs,"km")
                                    else:
                                        movetobase()
                                else:
                                    print(
                                        "INFO:",mp_use1,
                                        " nearby: ",round(config.dist_r2mp,2),
                                        " But critical distance not reached: ",
                                        config.mp_km_crit,"km")
                            if config.mp_use == mp_use1:
                                print("INFO: Always connected to ",mp_use1)
                        else:
                            print("INFO: Base dead")
                            movetobase()
        except serial.SerialException as e:
            #print('Device error: {}'.format(e))
            continue
        except pynmea2.ParseError as e:
            #print('Parse error: {}'.format(e))
            continue

if __name__ == '__main__':
    main()
