import socket
import psycopg2
import select
import os

t_host = os.getenv('HOST','localhost')
t_port = os.getenv('PORT','5432')
t_dbname = os.getenv('DB','gis')
t_user = os.getenv('USER','docker')
t_pw = os.getenv('PASS','docker')

conn = psycopg2.connect(host=t_host, port=t_port, dbname=t_dbname, user=t_user, password=t_pw)
cur = conn.cursor()

def insertData(vL):
    s = ""
    s += "INSERT INTO " + os.getenv('TBL','public.llh1') +" ("
    s += " dat,tim,lati,longi,height,q,ns,sdn,sde,sdu,age,ratio"
    s += ") VALUES ("
    s += "(%s),(%s),(%s),(%s),(%s),(%s),(%s),(%s),(%s),(%s),(%s),(%s)"
    s += ")"
    try:
        cur.execute(s,(vL[0],vL[1],vL[2],vL[3],vL[4],vL[5],vL[6],vL[7],vL[8],vL[9],vL[13],vL[14]))
        conn.commit()
        #print('data inject!')
    except psycopg2.Error as e:
        t_msg_err = "SQL error: " + e + "/n SQL: " #+ s
        return render_template("error.html", t_msg_err = t_msg_err)
    #cur.close()

def tab(vL):
    #print(str(vL)
    insertData(vL)

def socketSetup():
    # Server socket
    connSocket = socket.socket()
    print('Socket was created')
    # Bind socket to a port number.
    connSocket.bind(('0.0.0.0', 8090))
    return connSocket

def socketListen(connSocket):
    # how many clients?
    connSocket.listen(15)
    print('waiting for connections')
    clients=[]
    while True:
        rdSet=[connSocket]+clients;
        (readyR,readyW,readyE)=select.select(rdSet,[],[])
        for s in readyR:
             if s is connSocket:
                 (cursorSocket, addr)=connSocket.accept()
                 clients.append(cursorSocket)
             else:
                 print("Connected with addr: " + str(addr))
                 s.settimeout(2)
                 while True:
                     try:
                         valuesReceived = cursorSocket.recv(1024).decode()
                         if valuesReceived == '':
                             print(str(addr) + "Client disconnected")
                             s.close()
                             clients.remove(s)
                             break
                         vL = valuesReceived.split()
                         tab(vL)
                     except socket.timeout:
                         print(str(addr) + "Client dead")
                         s.close()
                         clients.remove(s)
                         break         
             
def main():
    sock = socketSetup()
    socketListen(sock)

if __name__ == "__main__":
    main()
