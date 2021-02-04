import time
import socket
import datetime

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect(('000.000.000.000', 5000))
client_socket.settimeout(10)
GPS_List = [0.0]
time.sleep(2)


string = "status 1" + '\r\n'
client_socket.send("status 1" + '\r\n')



dict = {}

while True:

        data = client_socket.recv(1024)
        lines = data.split("\n")
        for line in lines:
          print(line)
          cols = line.split(":")          
          if len(cols) >= 2:
            dict[cols[0].strip()] = cols[1].strip()
            print(cols[0])          
          key = 'rtklib version'
          key = 'rtk server thread'
          key = 'rtk server state'
          key = 'processing cycle (ms)'
          key = 'positioning mode'
          key = 'frequencies'
          key = 'accumulated time to run'
          key = 'cpu time for a cycle (ms)'
          key = 'missing obs data count'
          key = 'bytes in input buffer'
          key = '# of input data rover'
          key = '# of input data base'
          key = '# of input data corr'
          key = '# of rtcm messages rover'
          key = '# of rtcm messages base'
          key = '# of rtcm messages corr'
          key = 'solution status'
          key = 'time of receiver clock rover'
          key = 'time sys offset (ns)'
          key = 'solution interval (s)'
          key = 'age of differential (s)'
          key = 'ratio for ar validation'
          key = '# of satellites rover'
          key = '# of satellites base'
          key = '# of valid satellites'
          key = 'GDOP/PDOP/HDOP/VDOP'
          key = '# of real estimated states'
          key = '# of all estimated states'
          key = 'pos xyz single (m) rover'
          key = 'pos llh single (deg,m) rover'
          key = 'vel enu (m/s) rover'
          key = 'pos xyz float (m) rover'
          key = 'pos xyz float std (m) rover'
          key = 'pos xyz fixed (m) rover'
          key = 'pos xyz fixed std (m) rover'
          key = 'pos xyz (m) base'
          key = 'pos llh (deg,m) base'
          key = '# of average single pos base'
          key = 'ant type rover'
          key = 'ant delta rover'
          key = 'ant delta base'
          key = 'vel enu (m/s) base'
          key = 'baseline length float (m)'
          key = 'baseline length fixed (m)'
          key = 'last time mark'
          key = 'receiver time mark count'
          key = 'rtklib time mark count'
          if key in dict:
             #print('sats rover:'+dict['# of satellites rover'])
             #print('solution status:'+dict['solution status'])

             #for key in dict:
             #  print('KEY='+key+'  VALUE='+dict[key])

             
             #Split GDOP/PDOP/HDOP/VDOP in to diffrent parameters#
             GPHV = dict['GDOP/PDOP/HDOP/VDOP']
             GPHV_Split = GPHV.split(",")
             #print (GPHV_Split[0])
             #print (GPHV_Split[1])
             #print (GPHV_Split[2])
             #print (GPHV_Split[3])
             GDOP = GPHV_Split[0]
             PDOP = GPHV_Split[1]
             HDOP = GPHV_Split[2]
             PDOP = GPHV_Split[3]
             #print (GDOP)

             #pos xyz single (m) rover in to diffrent parameters#
             POS_Single = dict['pos xyz single (m) rover']
             POS_Single_Split = POS_Single.split(",")
             POS_Single_X = POS_Single_Split[0]
             POS_Single_Y = POS_Single_Split[1]
             POS_Single_Z = POS_Single_Split[2]
             #print (POS_Single_X)
             #print (POS_Single_Y)
             #print (POS_Single_Z)

             #vel enu (m/s) rover #
             VEL_Enu = dict['vel enu (m/s) rover']
             VEL_Enu_Split = VEL_Enu.split(",")
             VEL_Enu_E = VEL_Enu_Split[0]
             VEL_Enu_N = VEL_Enu_Split[1]
             VEL_Enu_U = VEL_Enu_Split[2]
             #print (VEL_Enu_E)
             #print (VEL_Enu_N)
             #print (VEL_Enu_U)

             #pos xyz float in to diffrent parameters#
             POS_XYZ_Float = dict['pos xyz float (m) rover']
             POS_XYZ_Float_Split = POS_XYZ_Float.split(",")
             POS_XYZ_Float_X = POS_XYZ_Float_Split[0]
             POS_XYZ_Float_Y = POS_XYZ_Float_Split[1]
             POS_XYZ_Float_Z = POS_XYZ_Float_Split[2]
             #print (POS_XYZ_Float_X)
             #print (POS_XYZ_Float_Y)
             #print (POS_XYZ_Float_Z)

             #pos xyz float std (m) rover in to diffrent parameters#
             POS_XYZ_Float_Std = dict['pos xyz float std (m) rover']
             POS_XYZ_Float_Std_Split = POS_XYZ_Float_Std.split(",")
             POS_XYZ_Float_Std_X = POS_XYZ_Float_Std_Split[0]
             POS_XYZ_Float_Std_Y = POS_XYZ_Float_Std_Split[1]
             POS_XYZ_Float_Std_Z = POS_XYZ_Float_Std_Split[2]
             #print (POS_XYZ_Float_Std_X)
             #print (POS_XYZ_Float_Std_Y)
             #print (POS_XYZ_Float_Std_Z)


             #pos xyz fixed (m) rover in to diffrent parameters#
             POS_XYZ_Fixed = dict['pos xyz fixed (m) rover']
             POS_XYZ_Fixed_Split = POS_XYZ_Fixed.split(",")
             POS_XYZ_Fixed_X = POS_XYZ_Fixed_Split[0]
             POS_XYZ_Fixed_Y = POS_XYZ_Fixed_Split[1]
             POS_XYZ_Fixed_Z = POS_XYZ_Fixed_Split[2]
             #print (POS_XYZ_Fixed_X)
             #print (POS_XYZ_Fixed_Y)
             #print (POS_XYZ_Fixed_Z)


             #pos xyz fixed std (m) rover in to diffrent parameters#
             POS_XYZ_Fixed_Std = dict['pos xyz fixed std (m) rover']
             POS_XYZ_Fixed_Std_Split = POS_XYZ_Fixed_Std.split(",")
             POS_XYZ_Fixed_Std_X = POS_XYZ_Fixed_Std_Split[0]
             POS_XYZ_Fixed_Std_Y = POS_XYZ_Fixed_Std_Split[1]
             POS_XYZ_Fixed_Std_Z = POS_XYZ_Fixed_Std_Split[2]
             #print (POS_XYZ_Fixed_Std_X)
             #print (POS_XYZ_Fixed_Std_Y)
             #print (POS_XYZ_Fixed_Std_Z)

             #pos xyz (m) base in to diffrent parameters#
             POS_XYZ_Base = dict['pos xyz (m) base']
             POS_XYZ_Base_Split = POS_XYZ_Base.split(",")
             POS_XYZ_Base_X = POS_XYZ_Base_Split[0]
             POS_XYZ_Base_Y = POS_XYZ_Base_Split[1]
             POS_XYZ_Base_Z = POS_XYZ_Base_Split[2]
             #print (POS_XYZ_Base_X)
             #print (POS_XYZ_Base_Y)
             #print (POS_XYZ_Base_Z)


             #pos llh (deg,m) base in to diffrent parameters#
             POS_LLH_Base = dict['pos llh (deg,m) base']
             POS_LLH_Base_Split = POS_LLH_Base.split(",")
             POS_LLH_Base_Latitude = POS_LLH_Base_Split[0]
             POS_LLH_Base_Longitude = POS_LLH_Base_Split[1]
             POS_LLH_Base_Height = POS_LLH_Base_Split[2]
             #print (POS_LLH_Base_Latitude)
             #print (POS_LLH_Base_Longitude)
             #print (POS_LLH_Base_Height)

             #ant delta rover e/n/u#
             ANT_Delta_Rover = dict['ant delta rover']
             ANT_Delta_Rover_Split = ANT_Delta_Rover.split(" ")
             ANT_Delta_Rover_E = ANT_Delta_Rover_Split[0]
             ANT_Delta_Rover_N = ANT_Delta_Rover_Split[1]
             ANT_Delta_Rover_U = ANT_Delta_Rover_Split[2]
             #print (ANT_Delta_Rover_E)
             #print (ANT_Delta_Rover_N)
             #print (ANT_Delta_Rover_U)

             #ant delta base e/n/u#
             #ANT_Delta_Base = dict['ant delta base']
             #ANT_Delta_Base_Split = ANT_Delta_Base.split(" ")
             #ANT_Delta_Base_E = ANT_Delta_Base_Split[0]
             #ANT_Delta_Base_N = ANT_Delta_Base_Split[1]
             #ANT_Delta_Base_U = ANT_Delta_Base_Split[2]
             #print (ANT_Delta_Base_E)
             #print (ANT_Delta_Base_N)
             #print (ANT_Delta_Base_U)

             #vel enu (m/s) base #
             #VEL_Enu_Base = dict['vel enu (m/s) base']
             #VEL_Enu_Base_Split = VEL_Enu_Base.split(",")
             #VEL_Enu_E = VEL_Enu_Base_Split[0]
             #VEL_Enu_N = VEL_Enu_Base_Split[1]
             #VEL_Enu_U = VEL_Enu_Base_Split[2]
             #print (VEL_Enu_E)
             #print (VEL_Enu_N)
             #print (VEL_Enu_U)

             #bytes in input buffer input data rover#
             INPUT_Data_Rover = dict['# of input data rover']
             #print (INPUT_Data_Rover)
             INPUT_Data_Rover_Split = INPUT_Data_Rover.split(",")
             INPUT_Data_Rover_obs_a = INPUT_Data_Rover_Split [0]
             INPUT_Data_Rover_nav_a = INPUT_Data_Rover_Split [1]
             INPUT_Data_Rover_gnav_a = INPUT_Data_Rover_Split [2]
             INPUT_Data_Rover_ion_a = INPUT_Data_Rover_Split [3]
             INPUT_Data_Rover_sbs_a = INPUT_Data_Rover_Split [4]
             INPUT_Data_Rover_pos_a = INPUT_Data_Rover_Split [5]
             INPUT_Data_Rover_dgps_a = INPUT_Data_Rover_Split [6]
             INPUT_Data_Rover_ssr_a = INPUT_Data_Rover_Split [7]
             INPUT_Data_Rover_err_a = INPUT_Data_Rover_Split [8]

             INPUT_Data_Rover_obs_b = INPUT_Data_Rover_obs_a.split('(')
             INPUT_Data_Rover_obs_c = INPUT_Data_Rover_obs_b[1]
             INPUT_Data_Rover_obs_d = INPUT_Data_Rover_obs_c.split(')')
             INPUT_Data_Rover_obs = INPUT_Data_Rover_obs_d [0]
             #print (INPUT_Data_Rover_obs)

             INPUT_Data_Rover_nav_b = INPUT_Data_Rover_nav_a.split('(')
             INPUT_Data_Rover_nav_c = INPUT_Data_Rover_nav_b[1]
             INPUT_Data_Rover_nav_d = INPUT_Data_Rover_nav_c.split(')')
             INPUT_Data_Rover_nav = INPUT_Data_Rover_nav_d [0]
             #print (INPUT_Data_Rover_nav)

             INPUT_Data_Rover_gnav_b = INPUT_Data_Rover_gnav_a.split('(')
             INPUT_Data_Rover_gnav_c = INPUT_Data_Rover_gnav_b[1]
             INPUT_Data_Rover_gnav_d = INPUT_Data_Rover_gnav_c.split(')')
             INPUT_Data_Rover_gnav = INPUT_Data_Rover_gnav_d [0]
             #print (INPUT_Data_Rover_gnav)

             INPUT_Data_Rover_ion_b = INPUT_Data_Rover_ion_a.split('(')
             INPUT_Data_Rover_ion_c = INPUT_Data_Rover_ion_b[1]
             INPUT_Data_Rover_ion_d = INPUT_Data_Rover_ion_c.split(')')
             INPUT_Data_Rover_ion = INPUT_Data_Rover_ion_d [0]
             #print (INPUT_Data_Rover_ion)

             INPUT_Data_Rover_sbs_b = INPUT_Data_Rover_sbs_a.split('(')
             INPUT_Data_Rover_sbs_c = INPUT_Data_Rover_sbs_b[1]
             INPUT_Data_Rover_sbs_d = INPUT_Data_Rover_sbs_c.split(')')
             INPUT_Data_Rover_sbs = INPUT_Data_Rover_sbs_d [0]
             #print (INPUT_Data_Rover_sbs)

             INPUT_Data_Rover_pos_b = INPUT_Data_Rover_pos_a.split('(')
             INPUT_Data_Rover_pos_c = INPUT_Data_Rover_pos_b[1]
             INPUT_Data_Rover_pos_d = INPUT_Data_Rover_pos_c.split(')')
             INPUT_Data_Rover_pos = INPUT_Data_Rover_pos_d [0]
             #print (INPUT_Data_Rover_pos)

             INPUT_Data_Rover_dgps_b = INPUT_Data_Rover_dgps_a.split('(')
             INPUT_Data_Rover_dgps_c = INPUT_Data_Rover_dgps_b[1]
             INPUT_Data_Rover_dgps_d = INPUT_Data_Rover_dgps_c.split(')')
             INPUT_Data_Rover_dgps = INPUT_Data_Rover_dgps_d [0]
             #print (INPUT_Data_Rover_dgps)

             INPUT_Data_Rover_ssr_b = INPUT_Data_Rover_ssr_a.split('(')
             INPUT_Data_Rover_ssr_c = INPUT_Data_Rover_ssr_b[1]
             INPUT_Data_Rover_ssr_d = INPUT_Data_Rover_ssr_c.split(')')
             INPUT_Data_Rover_ssr = INPUT_Data_Rover_ssr_d [0]
             #print (INPUT_Data_Rover_ssr)

             INPUT_Data_Rover_err_b = INPUT_Data_Rover_err_a.split('(')
             INPUT_Data_Rover_err_c = INPUT_Data_Rover_err_b[1]
             INPUT_Data_Rover_err_d = INPUT_Data_Rover_err_c.split(')')
             INPUT_Data_Rover_err = INPUT_Data_Rover_err_d [0]
             #print (INPUT_Data_Rover_err)


             #bytes in input buffer of input data base#
             INPUT_Data_Base = dict['# of input data base']
             #print (INPUT_Data_Base)
             INPUT_Data_Base_Split = INPUT_Data_Base.split(",")
             INPUT_Data_Base_obs_a = INPUT_Data_Base_Split [0]
             INPUT_Data_Base_nav_a = INPUT_Data_Base_Split [1]
             INPUT_Data_Base_gnav_a = INPUT_Data_Base_Split [2]
             INPUT_Data_Base_ion_a = INPUT_Data_Base_Split [3]
             INPUT_Data_Base_sbs_a = INPUT_Data_Base_Split [4]
             INPUT_Data_Base_pos_a = INPUT_Data_Base_Split [5]
             INPUT_Data_Base_dgps_a = INPUT_Data_Base_Split [6]
             INPUT_Data_Base_ssr_a = INPUT_Data_Base_Split [7]
             INPUT_Data_Base_err_a = INPUT_Data_Base_Split [8]

             INPUT_Data_Base_obs_b = INPUT_Data_Base_obs_a.split('(')
             INPUT_Data_Base_obs_c = INPUT_Data_Base_obs_b[1]
             INPUT_Data_Base_obs_d = INPUT_Data_Base_obs_c.split(')')
             INPUT_Data_Base_obs = INPUT_Data_Base_obs_d [0]
             #print (INPUT_Data_Base_obs)

             INPUT_Data_Base_nav_b = INPUT_Data_Base_nav_a.split('(')
             INPUT_Data_Base_nav_c = INPUT_Data_Base_nav_b[1]
             INPUT_Data_Base_nav_d = INPUT_Data_Base_nav_c.split(')')
             INPUT_Data_Base_nav = INPUT_Data_Base_nav_d [0]
             #print (INPUT_Data_Base_nav)

             INPUT_Data_Base_gnav_b = INPUT_Data_Base_gnav_a.split('(')
             INPUT_Data_Base_gnav_c = INPUT_Data_Base_gnav_b[1]
             INPUT_Data_Base_gnav_d = INPUT_Data_Base_gnav_c.split(')')
             INPUT_Data_Base_gnav = INPUT_Data_Base_gnav_d [0]
             #print (INPUT_Data_Base_gnav)

             INPUT_Data_Base_ion_b = INPUT_Data_Base_ion_a.split('(')
             INPUT_Data_Base_ion_c = INPUT_Data_Base_ion_b[1]
             INPUT_Data_Base_ion_d = INPUT_Data_Base_ion_c.split(')')
             INPUT_Data_Base_ion = INPUT_Data_Base_ion_d [0]
             #print (INPUT_Data_Base_ion)

             INPUT_Data_Base_sbs_b = INPUT_Data_Base_sbs_a.split('(')
             INPUT_Data_Base_sbs_c = INPUT_Data_Base_sbs_b[1]
             INPUT_Data_Base_sbs_d = INPUT_Data_Base_sbs_c.split(')')
             INPUT_Data_Base_sbs = INPUT_Data_Base_sbs_d [0]
             #print (INPUT_Data_Base_sbs)

             INPUT_Data_Base_pos_b = INPUT_Data_Base_pos_a.split('(')
             INPUT_Data_Base_pos_c = INPUT_Data_Base_pos_b[1]
             INPUT_Data_Base_pos_d = INPUT_Data_Base_pos_c.split(')')
             INPUT_Data_Base_pos = INPUT_Data_Base_pos_d [0]
             #print (INPUT_Data_Base_pos)

             INPUT_Data_Base_dgps_b = INPUT_Data_Base_dgps_a.split('(')
             INPUT_Data_Base_dgps_c = INPUT_Data_Base_dgps_b[1]
             INPUT_Data_Base_dgps_d = INPUT_Data_Base_dgps_c.split(')')
             INPUT_Data_Base_dgps = INPUT_Data_Base_dgps_d [0]
             #print (INPUT_Data_Base_dgps)

             INPUT_Data_Base_ssr_b = INPUT_Data_Base_ssr_a.split('(')
             INPUT_Data_Base_ssr_c = INPUT_Data_Base_ssr_b[1]
             INPUT_Data_Base_ssr_d = INPUT_Data_Base_ssr_c.split(')')
             INPUT_Data_Base_ssr = INPUT_Data_Base_ssr_d [0]
             #print (INPUT_Data_Base_ssr)

             INPUT_Data_Base_err_b = INPUT_Data_Base_err_a.split('(')
             INPUT_Data_Base_err_c = INPUT_Data_Base_err_b[1]
             INPUT_Data_Base_err_d = INPUT_Data_Base_err_c.split(')')
             INPUT_Data_Base_err = INPUT_Data_Base_err_d [0]
             #print (INPUT_Data_Base_err)


             #bytes in input buffer of input data corr#
             INPUT_Data_corr = dict['# of input data corr']
             #print (INPUT_Data_corr)
             INPUT_Data_corr_Split = INPUT_Data_corr.split(",")
             INPUT_Data_corr_obs_a = INPUT_Data_corr_Split [0]
             INPUT_Data_corr_nav_a = INPUT_Data_corr_Split [1]
             INPUT_Data_corr_gnav_a = INPUT_Data_corr_Split [2]
             INPUT_Data_corr_ion_a = INPUT_Data_corr_Split [3]
             INPUT_Data_corr_sbs_a = INPUT_Data_corr_Split [4]
             INPUT_Data_corr_pos_a = INPUT_Data_corr_Split [5]
             INPUT_Data_corr_dgps_a = INPUT_Data_corr_Split [6]
             INPUT_Data_corr_ssr_a = INPUT_Data_corr_Split [7]
             INPUT_Data_corr_err_a = INPUT_Data_corr_Split [8]

             INPUT_Data_corr_obs_b = INPUT_Data_corr_obs_a.split('(')
             INPUT_Data_corr_obs_c = INPUT_Data_corr_obs_b[1]
             INPUT_Data_corr_obs_d = INPUT_Data_corr_obs_c.split(')')
             INPUT_Data_corr_obs = INPUT_Data_corr_obs_d [0]
             #print (INPUT_Data_corr_obs)

             INPUT_Data_corr_nav_b = INPUT_Data_corr_nav_a.split('(')
             INPUT_Data_corr_nav_c = INPUT_Data_corr_nav_b[1]
             INPUT_Data_corr_nav_d = INPUT_Data_corr_nav_c.split(')')
             INPUT_Data_corr_nav = INPUT_Data_corr_nav_d [0]
             #print (INPUT_Data_corr_nav)

             INPUT_Data_corr_gnav_b = INPUT_Data_corr_gnav_a.split('(')
             INPUT_Data_corr_gnav_c = INPUT_Data_corr_gnav_b[1]
             INPUT_Data_corr_gnav_d = INPUT_Data_corr_gnav_c.split(')')
             INPUT_Data_corr_gnav = INPUT_Data_corr_gnav_d [0]
             #print (INPUT_Data_corr_gnav)

             INPUT_Data_corr_ion_b = INPUT_Data_corr_ion_a.split('(')
             INPUT_Data_corr_ion_c = INPUT_Data_corr_ion_b[1]
             INPUT_Data_corr_ion_d = INPUT_Data_corr_ion_c.split(')')
             INPUT_Data_corr_ion = INPUT_Data_corr_ion_d [0]
             #print (INPUT_Data_corr_ion)

             INPUT_Data_corr_sbs_b = INPUT_Data_corr_sbs_a.split('(')
             INPUT_Data_corr_sbs_c = INPUT_Data_corr_sbs_b[1]
             INPUT_Data_corr_sbs_d = INPUT_Data_corr_sbs_c.split(')')
             INPUT_Data_corr_sbs = INPUT_Data_corr_sbs_d [0]
             #print (INPUT_Data_corr_sbs)

             INPUT_Data_corr_pos_b = INPUT_Data_corr_pos_a.split('(')
             INPUT_Data_corr_pos_c = INPUT_Data_corr_pos_b[1]
             INPUT_Data_corr_pos_d = INPUT_Data_corr_pos_c.split(')')
             INPUT_Data_corr_pos = INPUT_Data_corr_pos_d [0]
             #print (INPUT_Data_corr_pos)

             INPUT_Data_corr_dgps_b = INPUT_Data_corr_dgps_a.split('(')
             INPUT_Data_corr_dgps_c = INPUT_Data_corr_dgps_b[1]
             INPUT_Data_corr_dgps_d = INPUT_Data_corr_dgps_c.split(')')
             INPUT_Data_corr_dgps = INPUT_Data_corr_dgps_d [0]
             #print (INPUT_Data_corr_dgps)

             INPUT_Data_corr_ssr_b = INPUT_Data_corr_ssr_a.split('(')
             INPUT_Data_corr_ssr_c = INPUT_Data_corr_ssr_b[1]
             INPUT_Data_corr_ssr_d = INPUT_Data_corr_ssr_c.split(')')
             INPUT_Data_corr_ssr = INPUT_Data_corr_ssr_d [0]
             #print (INPUT_Data_corr_ssr)

             INPUT_Data_corr_err_b = INPUT_Data_corr_err_a.split('(')
             INPUT_Data_corr_err_c = INPUT_Data_corr_err_b[1]
             INPUT_Data_corr_err_d = INPUT_Data_corr_err_c.split(')')
             INPUT_Data_corr_err = INPUT_Data_corr_err_d [0]
             #print (INPUT_Data_corr_err)


             #time of receiver clock rover ####TO FIX####
             time_clock_rover = dict['time of receiver clock rover']
             #date_rover = datetime.datetime.strptime(time_clock_rover, "%Y/%m/%d %H:%M:%S.%f")
             date_rover = datetime.datetime.strptime(time_clock_rover, "%Y/%m/%d %H")
             #print (date_rover)





      
        
        time.sleep(0.1)
        #print(dict)

