# CENTIPEDE Caster Base Variable

Your ntripclient must be able to send its position:
* [Lefebure](https://play.google.com/store/apps/details?id=com.lefebure.ntripclient&hl=fr&gl=fr) :x:
* [BluetoothGNSS](https://play.google.com/store/apps/details?id=com.clearevo.bluetooth_gnss&hl=fr&gl=fr) :heavy_check_mark:
* [Swmaps](https://play.google.com/store/apps/details?id=np.com.softwel.swmaps&hl=fr&gl=fr) :heavy_check_mark:
* [RtkGPS+](https://docs.centipede.fr/docs/Rover_rtklib_android/#application-rtkgps-android-open-source) :heavy_check_mark:
* [RTKNAVI](http://rtkexplorer.com/downloads/rtklib-code/) :heavy_check_mark:
* [RTKRCV](https://github.com/tomojitakasu/RTKLIB) :heavy_check_mark:

## Create a alert Telegram when Base GNSS change (option)

* [Creating a Telegram bot account](https://usp-python.github.io/06-bot/)
* Get your **APIKEY** and **USERID** and complete and complete the ```./basevar/.env``` file.

## first Build & Run:

```cd ./basevar```
```docker-compose up```

or first Build & Run as deamon:

```cd ./basevar```
```docker-compose up -d```

## Connect your rover ntrip client

* connect your ntripclient to:
  * Your ip or DNS
  * Port: 9999
  * Mount name: ME

Now basevar get NMEA data from Rover every X seconds, check lon lat, research nearest Base GNSS on the caster Centipede and create a connexion.

## manual Build

```docker build -t basevar .```

 or

```docker build -t basevar . --no-cache```

## Run as demon

```docker run -td --name caster_basevar -p 9999:9999  basevar```

## Debug RUN

```docker run -it  --rm --name caster_basevar -p 9999:9999 -v ./pybasevar:/home --entrypoint bash basevar```
```sh /home/run.sh```

 or

```docker run -it  --rm --name caster_basevar -p 9999:9999  basevar```

## Debug inside container

```docker exec -it caster_basevar bash```
