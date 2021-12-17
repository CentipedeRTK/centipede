# CENTIPEDE Caster Base Variable

## Build & Run:

```cd ./basevar```
```docker-compose up```

## Build & Run as deamon:

```docker-compose up -d```

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
