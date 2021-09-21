#!/bin/sh
##TODO run with variable .env
docker-compose exec postgiscaster sh -c "PGPASSWORD=centipedepswd  pg_dump --inserts --format=t --host=localhost --port=5432 -U centipede centipededb > /srv/centipede/centipede_$(date +%A).tar"
docker-compose exec postgiscaster sh -c "PGPASSWORD=centipedepswd pg_dump --inserts --format=p --host=localhost --port=5432 -U centipede centipededb > /srv/centipede/centipede.sql"
