#!/bin/sh

# Module d'importation des log du emlidReach vers une base postgis

# l'écoute du dossier est fait par incron:
## apt-get install incron
## ajouter l'utilisateur dans /etc/incron.allow
## créer une tache: incrontab -e 
## home/mySpace/files/ IN_CREATE /bin/sh /home/mySpace/autoDump.sh

#chemin des dossiers origine et temporaire
VAR1=/home/mySpace/files/
VAR2=/home/my_space/llh
VAR2DOCKER=/home/my_space/llh/

sleep 30  &&
#récupère le nom du dernier fichier mofié
FICHIER=$(ls -1t $VAR1 | grep \.zip | head -1) &&

##déplace le csv dans le bon rep
unzip -d $VAR2 $VAR1$FICHIER &&

FICHIER2=$(ls -1t $VAR2/ |  head -1) &&

###remplacer les espaces par des virgules
sed -i -r 's/^ *//;s/ {1,}/,/g' $VAR2/$FICHIER2 &&

## insère les données dans la base
docker exec -u postgres sig_postgis psql unlimited -c "COPY unlimited(jour,heure,latitude,longitude,height,rtk_fix_float_sbas_dgps_single_ppp,satellites,sdn,sde,sdu,sdne,sdeu,sdun,age,ratio) FROM '$VAR2DOCKER$FICHIER2' DELIMITER ',' csv encoding 'UTF-8';" &&

##supprime le fichier data
rm $VAR2/$FICHIER2
