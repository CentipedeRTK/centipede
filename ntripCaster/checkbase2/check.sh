#!/bin/bash
#script to check caster
#INSTALL postgresql-client-12
#sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
#wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
#sudo apt-get update
#sudo apt install postgresql-client-12
##RUN SCRIPT
#watch -n 15 ./check.sh
#OR service + service.timer 15s
#https://twpower.github.io/212-systemd-timer-example-en
#sudo systemctl enable check_caster
#sudo systemctl start check_caster.timer

SERVER=localhost:2101/admin?mode=sources
USER=me
PASS=mypasswd
DB_USER=user
DB_PSW='mypasswd!'
DB_IP=localhost:5432
DB_NAME=database_name
TABLE="public.defaut"

#get sources
MP=$(curl -u $USER:$PASS http://$SERVER | \
#extract html data
          grep '^<tr><td>' \
	| sed              \
    	-e 's:<tr>::g'     \
    	-e 's:</tr>::g'    \
    	-e 's:</td>::g'    \
    	-e 's:<td>: :g'    \
	-e 's:/: :g'       \
	-e 's/\<Id\>//g'   \
        | cut -d " " -f3 )
#read list for information
echo $MP

#insert values on database
for i in $MP
do
  psql --command="INSERT INTO $TABLE (mp,control) 
		  VALUES ('$i',now()) 
		  ON CONFLICT (mp) 
		  DO UPDATE SET (control,defaut_count) = (now(),0);" \
  postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME
done
#check if bases are alive
CH=$(psql --command="COPY (SELECT mp FROM $TABLE 
		     WHERE control < (now()- interval '15 seconds')) 
		     TO STDOUT WITH DELIMITER ' ';" \
     postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME)
echo $CH
##insert in database
for c in $CH
do
  psql --command="UPDATE $TABLE a 
		  SET (defaut,defaut_persist,defaut_count) = (control,now() - control,defaut_count +1) 
		  WHERE mp='$c';" \
  postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME
done

#Mail 5 min default
MA5=$(psql --command="COPY (SELECT mp FROM $TABLE WHERE defaut_count = 20) TO STDOUT WITH DELIMITER ' ';" postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME)
echo $MA5
for m in $MA5
do
MAIL=$(psql -t --command="SELECT cont.mail FROM centipede.contact as cont LEFT JOIN public.antenne as ant ON ant.id = cont.id_antenne WHERE ant.mp = '$m' AND ant.ping_date NOTNULL;"  postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME) &&
      if [ -z "$MAIL" ]
      then
        echo "base " $m "non déclaré "
      else
        docker run --rm -e MP=$m -e MAIL="$MAIL" -e MIN=5 \
	-v /home/centipede/checkbase2/smtp/ssmtp.conf:/etc/ssmtp/ssmtp.conf \
	-v /home/centipede/checkbase2/smtp/mail.sh:/home/mail.sh jancelin/centipede:ssmtp &&
        echo "mail sent to " $MAIL" !!!"
      fi
done

#Mail re-connection reseau 5 min  + 15 secondes
MAON=$(psql --command="COPY (SELECT mp FROM $TABLE 
			WHERE control > ((defaut+defaut_persist) + interval '15 seconds')
			AND  control < ((defaut+defaut_persist) + interval '30 seconds')
			AND defaut_persist > interval '5 minutes'
			AND defaut_count = 0) TO STDOUT WITH DELIMITER ' ';" postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME)
echo $MAON
for n in $MAON
do
MAIL=$(psql -t --command="SELECT cont.mail FROM centipede.contact as cont LEFT JOIN public.antenne as ant ON ant.id = cont.id_antenne WHERE ant.mp = '$n' AND ant.ping_date NOTNULL;"  postgresql://$DB_USER:$DB_PSW@$DB_IP/$DB_NAME) &&
      if [ -z "$MAIL" ]
      then
        echo "base " $n "non déclaré "
      else
        docker run --rm -e MP=$n -e MAIL="$MAIL" -e MIN=5 \
	-v /home/centipede/checkbase2/smtp/ssmtp.conf:/etc/ssmtp/ssmtp.conf \
	-v /home/centipede/checkbase2/smtp/mail_activ.sh:/home/mail.sh jancelin/centipede:ssmtp &&
        echo "mail UP sent to " $MAIL" !!!"
      fi
done



