import io
import serial
import pynmea2
import time
import subprocess
import os
import signal
import telegram
import telebot
from telebot import types
import sys
from decimal import *
from ntripbrowser import NtripBrowser
from multiprocessing import Process
from datetime import datetime
import config
import configparser

## import and edit .ini
configp = configparser.ConfigParser()
configp.read('param.ini')

def editparam():
    with open('param.ini','w') as configfile:
        configp.write(configfile)


##TElegram param
config.api_key = str( sys.argv[1] )
config.user_id = str( sys.argv[2] )

bot = telebot.TeleBot(config.api_key)

@bot.message_handler(commands=['help'])
def send_welcome(message):
	bot.reply_to(message, "Howdy, how are you doing?")

@bot.message_handler(commands=['mp'])
def send_mp(message):
    configp.read('param.ini')
    bot.reply_to(message,"Mount Point: "+configp["data"]["mp_use"])

@bot.message_handler(commands=['dist'])
def send_mp_use1_km(message):
    configp.read('param.ini')
    bot.reply_to(message,"Distance between Rover/Base: "+configp["data"]["dist_r2mp"]+"km")

#hysteresis
@bot.message_handler(commands=['htrs'])
def send_htrs(message):
    configp.read('param.ini')
    bot.reply_to(message,"Hysteresis: "+configp["data"]["htrs"]+"km")
@bot.message_handler(commands=['htrs!'])
def send_htrsE(message):
    configp.read('param.ini')
    msg = bot.reply_to(message,"Edit Hysteresis: old value:"+configp["data"]["htrs"]+"km, New value ? ")
    bot.register_next_step_handler(msg, processSetHtrs)
def processSetHtrs(message):
    answer = message.text
    if answer.isdigit():
        print(answer)
        configp["data"]["htrs"] = answer
        stoptowrite()
        bot.reply_to(message,"NEW Hysteresis: "+configp["data"]["htrs"]+"km")
    else:
        bot.reply_to(message, 'Oooops bad value!')

#Critical distance
@bot.message_handler(commands=['crit'])
def send_crit(message):
    configp.read('param.ini')
    bot.reply_to(message, "Critical distance: "+ configp["data"]["mp_km_crit"] +"km")
@bot.message_handler(commands=['crit!'])
def send_critE(message):
    configp.read('param.ini')
    msg = bot.reply_to(message,"Edit critical distance: old value:"+configp["data"]["mp_km_crit"]+"km, New value ? ")
    bot.register_next_step_handler(msg, processSetCrit)
def processSetCrit(message):
    answer = message.text
    if answer.isdigit():
        print(answer)
        configp["data"]["mp_km_crit"] = answer
        stoptowrite()
        bot.reply_to(message,"NEW Critical distance: "+configp["data"]["mp_km_crit"]+"km")
    else:
        bot.reply_to(message, 'Oooops bad value!')

@bot.message_handler(commands=['log'])
def notas(mensagem):
    mensagemID = mensagem.chat.id
    doc = open('basevarlog.csv', 'rb')
    bot.send_document(mensagemID, doc)

@bot.message_handler(func=lambda message: True)
def echo_all(message):
	bot.reply_to(message, "What?")


## 00-START socat
## TODO : Open virtual ports, BUG don't run in background, use run.sh.
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

def telegrambot():
    global bot1
    if len(sys.argv) >= 2:
        bot1 = telegram.Bot(token=config.api_key)
        bot1.send_message(chat_id=config.user_id, text=configp["message"]["message"])

def savelog():
    ##log in file
    file = open("basevarlog.csv", "a")
    file.write(configp["message"]["message"] +'\n')
    file.close

def movetobase():
    ## Build new str2str_in command
    bashstr = config.stream1 + mp_use1 + config.stream2
    ## LOG Move to base
    print("------")
    print("CASTER: Move to base ",mp_use1, " !")
    print("------")
    ## KILL old str2str_in
    killstr = "kill -9 " + str(config.pid_str)
    str2str = subprocess.Popen(killstr.split())
    print("STR2STR: KILL, old pid:", config.pid_str)
    ## Upd variables & Running a new str2str_in service
    #config.mp_use = mp_use1
    configp["data"]["mp_use"] = mp_use1
    editparam()
    time.sleep(3)
    str2str = subprocess.Popen(bashstr.split())
    config.pid_str = str2str.pid
    ##Metadata
    presentday = datetime.now()
    configp["message"]["message"] = ("Move to base ," + str(mp_use1) +","+
    str(round(mp_use1_km,2))+","+str(round(config.rlat,7))+","+
    str(round(config.rlon,7))+","+ presentday.strftime('%Y-%m-%d') +" "+str(config.rtime))
    editparam()
    telegrambot()
    # with open('param.ini','w') as configfile:
    #     configp.write(configfile)
    #     configfile.close()

def ntripbrowser():
    global browser
    global getmp
    global flt1
    global mp_use1
    global mp_use1_km
    global mp_Carrier
    ## 2-Get caster sourcetable
    browser = (NtripBrowser(config.caster, port=config.port,
    timeout=10,coordinates=(config.rlat,config.rlon),
    maxdist=int(configp["data"]["maxdist"]) ))
    getmp= browser.get_mountpoints()
    flt = getmp['str']
    # Purge list
    flt1 = []
    ## filter carrier L1-L2
    flt1 = [m for m in flt if int(m['Carrier'])>=2]
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
                configp["data"]["mp_use"],Decimal(configp["data"]["dist_r2mp"]),"km")

    ## Value on connected base
    flt_r2mp = [m for m in flt if m['Mountpoint']==configp["data"]["mp_use"]]
    ## GET distance between rover and mountpoint used.
    for r in flt_r2mp:
        configp["data"]["dist_r2mp"] = str(round(r["Distance"],2))
        configp["data"]["mp_alive"] = r['Mountpoint']
        editparam()
    ## LOG Watch all nearests mountpoints
    # for i in flt:
    #     mp = i["Mountpoint"]
    #     di = round(i["Distance"],2)
    #     car = i["Carrier"]
    #     print(mp,di,"km; Carrier:", car)

## 03-START loop to check base alive + rover position and nearest base
def loop_mp():
    while True:
        try:
            global mp_use1
            global mp_use1_km
            global msg
            ##get variables
            configp.read('param.ini')
            ##Get data from Caster
            ntripbrowser()
            ##My base is Alive?
            flt_basealive = [m for m in flt1 if m['Mountpoint']==configp["data"]["mp_alive"]]
            if len(flt_basealive) == 0:
                print("INFO: Base ",configp["data"]["mp_alive"]," is DEAD!")
                movetobase()
                savelog()
            else:
                print("INFO: Connected to ",configp["data"]["mp_use"],", Waiting for the rover's geographical coordinates......")
                ## 1-Analyse nmea from gnss ntripclient for get lon lat
                ##TODO after x min reset parameters
                line = config.sio.readline()
                msg = pynmea2.parse(line)
                ## Exclude bad longitude
                if msg.longitude != config.lon:
                    ## LOG coordinate from Rover
                    config.rlat = msg.latitude
                    config.rlon = msg.longitude
                    config.rtime = msg.timestamp
                    print("------")
                    print("ROVER: ",config.rlat,config.rlon,msg.timestamp)
                    print("------")
                    ## 2-Get caster sourcetable
                    ntripbrowser()
                    ### Check if it is necessary to change the base
                    ## nearest Base is different?
                    if configp["data"]["mp_use"] != mp_use1:
                        ## Check Critical distance before change ?
                        if Decimal(configp["data"]["dist_r2mp"]) > int(configp["data"]["mp_km_crit"]):
                            ##critique + Hysteresis(htrs)
                            crithtrs = int(configp["data"]["mp_km_crit"]) + int(configp["data"]["htrs"])
                            if Decimal(configp["data"]["dist_r2mp"]) < crithtrs:
                                print("**INFO: Hysteresis critique running: ",crithtrs,"km")
                            else:
                                ##middle mount point 2 mount point hysteresis
                                r2mphtrs = mp_use1_km + int(configp["data"]["htrs"])
                                if Decimal(configp["data"]["dist_r2mp"]) < r2mphtrs:
                                    print("**INFO: Hysteresis MP 2 MP running: ",r2mphtrs,"km")
                                else:
                                    movetobase()
                                    savelog()
                        else:
                            print(
                                "**INFO:",mp_use1," nearby: ",Decimal(configp["data"]["dist_r2mp"]),
                                " But critical distance not reached: ",configp["data"]["mp_km_crit"],"km")
                    if configp["data"]["mp_use"] == mp_use1:
                        print("**INFO: Always connected to ",mp_use1)

        except serial.SerialException as e:
            #print('Device error: {}'.format(e))
            continue
        except pynmea2.ParseError as e:
            #print('Parse error: {}'.format(e))
            continue

## stop loop for change parameters (.ini)
def stoptowrite():
    run = Run()
    os.kill(run.ppid, signal.SIGSTOP)
    editparam()
    p=Process(target=loop_mp)
    p.start()
    Run.ppid=p.pid
    print("New ppid",Run.ppid)


class Run:
    ppid = 0
    def loop():
        ## 03-START loop to check rover position and nearest base
        p=Process(target=loop_mp)
        p.start()
        Run.ppid=p.pid
        print("ppid",Run.ppid)

    def main():
        #logging.basicConfig(filename='pybasevar.log', filemode='a',format='%(asctime)s - %(message)s', level=logging.INFO)
        ## 00-START socat
        ## TODO
        ## 01-START caster
        Process(target=str2str_out).start()
        ## 02-START a generic stream RTCM3 in
        bashstr = config.stream1+configp["data"]["mp_use"]+config.stream2
        str2str = subprocess.Popen(bashstr.split())
        ## 4-Get str2str in pid
        config.pid_str = str2str.pid
        print("STR2STR: Defaut ntripcli 2 serial is runnig, pid: ",config.pid_str)
        print("START loop")
        ## 03-START loop to check rover position and nearest base
        p=Process(target=loop_mp)
        p.start()
        Run.ppid=p.pid
        ## 04-START botquestion:
        print("START bot question")
        bot.infinity_polling()


if __name__ == '__main__':
    Run.main()
