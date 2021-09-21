#!/bin/sh
#modify lizmap admin pswd
echo "----------------------------"
echo "Start upd Lizmap"
echo "----------------------------"
echo $LIZMAP_ADMIN_PSWD > /tmp/pswd
#and qgis file with .env data (potgis db env)
QGISFILE=$(find /srv/projects/ -type f -iname '*.qgs')
#https://www.developpez.net/forums/d1426222/systemes/linux/shell-commandes-gnu/sed-remplacer-chaine-precede-chaine/
sed -i.bak "s#\(<datasource>dbname=\)\(.*\)\(sslmode\)#<datasource>dbname='"$POSTGRES_DBNAME"' host=postgiscaster port=5432 user='"$POSTGRES_USER"' password='"$POSTGRES_PASS"'\ \\3#" $QGISFILE
sed -i.bak "s#\(<layer-tree-layer\)\(.*\)\(sslmode\)#<layer-tree-layer legend_exp=\"\"\ source=\"\dbname='"$POSTGRES_DBNAME"' host=postgiscaster port=5432 user='"$POSTGRES_USER"' \ \\3#" $QGISFILE
##TODO Logs déconnexions: &lt;strong>&lt;a href="http://localhost:3001/d/Nfy_d4G7z/centipede_log_base?orgId=1&amp;var-mount_name=[% "mp" %]&amp;kiosk" target="_blank">Logs [% "mp" %]&lt;/a>&lt;/strong>&lt;/p></mapTip>
#change rules
chown -R 1010:1010 /www /tmp/pswd /srv/projects/cent_admin/media/upload ;
echo "----------------------------"
echo "Files update with .env data"
echo "----------------------------"
exit 0
