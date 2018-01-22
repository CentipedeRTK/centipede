#!/usr/bin/python

import time
import wificontrol

time.sleep( 120 )
wifi = wificontrol.WiFiControl()
wifi.start_connecting({'ssid': 'rtk'})
