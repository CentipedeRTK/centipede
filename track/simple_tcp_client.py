# TCP client for listen rtklib LLh solution
import socket

#Receptor IP + port
IPADDR = '127.0.0.1'
PORTNUM = 9000

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

s.connect((IPADDR, PORTNUM))

while True:
    valuesReceived = s.recv(1024).decode()
    valuesList = valuesReceived.split()
    #print(str(valuesList))
    date = valuesList[0]
    time = valuesList[1]
    lati = valuesList[2]
    longi = valuesList[3]
    height = valuesList[4]
    print("date: " + str(date))
    print("lat: " + str(lati))
    print("long: " + str(longi))
    print("height: " + str(height))

s.close()





