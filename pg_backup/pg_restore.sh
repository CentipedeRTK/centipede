#!/bin/sh
##TODO run with variable .env
docker-compose exec postgiscaster sh -c "PGPASSWORD=centipedepswd pg_restore --host localhost --port 5432 --username "centipede" --dbname "centipededb" --role "postgres" --no-password  --verbose "/srv/centipede/centipede_mardi.tar""
