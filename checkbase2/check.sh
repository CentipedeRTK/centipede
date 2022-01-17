#!/bin/bash
#script to check base GNSS connexion to Caster.
TABLE="logs.defaut"
##Config mail sender with .env file
SSMTP=/etc/ssmtp/ssmtp.conf
sed -i.bak 's/^rewriteDomain=.*/rewriteDomain='$REWRITEDOMAIN'/' $SSMTP
sed -i.bak 's/^AuthUser=.*/AuthUser='$AUTHUSER'/' $SSMTP
sed -i.bak 's/^AuthPass=.*/AuthPass='$AUTHPSWD'/' $SSMTP
sed -i.bak 's/^mailhub=.*/mailhub='$MAILHUB'/' $SSMTP
#cat $SSMTP
while :
  do
    ##GET current min & second
    HEUR=$(date +%M:%S)
    echo "MIN:SS "$HEUR
    ##GET connected Mount Point
    MP=$(python3 /home/browser.py)
    echo "---List of GNSS BASES connected to $SERVER---"
    echo $MP
    echo "----------------"
    ##Insert values on database
    for i in $MP
    do
      psql --command="INSERT INTO $TABLE (mp,control)
    		  VALUES ('$i',now())
    		  ON CONFLICT (mp)
    		  DO UPDATE SET (control,defaut_count) = (now(),0);" \
      postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME
    done

    ##Check potential connected bases are
    CH=$(psql --command="COPY (SELECT $TABLE.mp
            FROM $TABLE
    		    WHERE $TABLE.control < (now()- interval '15 seconds')
            ORDER BY $TABLE.mp)
    		    TO STDOUT WITH DELIMITER ' ';" \
         postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME)
    echo "---Bases Down ---"
    echo $CH
    echo "---------------------------"
    ###Insert deconnection in database
    for c in $CH
    do
      psql --command="UPDATE $TABLE a
    		  SET (defaut,defaut_persist,defaut_count) = (control,now() - control,defaut_count +1)
    		  WHERE mp='$c';" \
      postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME
    done

    ##Mail after 5 min (15s * 20 = 5 min) default
    MA5=$(psql --command="COPY (SELECT mp
          FROM $TABLE
          WHERE defaut_count = 14) TO STDOUT WITH DELIMITER ' ';" \
        postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME)
    echo "---Send defaut mail 5 min to---"
    echo $MA5
    echo "-------------------------------"
    for m in $MA5
    do
      ##Variable: Get mails adresses by Mount Point
      MAIL=$(psql -t --command="SELECT cont.mail
              FROM centipede.contact as cont
              LEFT JOIN public.antenne as ant ON ant.id = cont.id_antenne
              WHERE ant.mp = '$m'
                AND ant.ping_date NOTNULL;"  \
            postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME)
      if [ -z "$MAIL" ]
      then
        echo "base " $m "non déclaré "
      else
        export MAIL=$MAIL
        export MP=$m
        /home/mail.sh
        echo "mail base  sent to " $MAIL" !!!"
      fi
    done

    ##Mail re-connection reseau if 5 min  + 15 secondes closed
    MAON=$(psql --command="COPY (
            SELECT mp
            FROM $TABLE
      			WHERE control > ((defaut+defaut_persist) + interval '15 seconds')
      			   AND  control < ((defaut+defaut_persist) + interval '30 seconds')
      			   AND defaut_persist > interval '5 minutes'
      			   AND defaut_count = 0) TO STDOUT WITH DELIMITER ' ';" \
          postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME)
    echo "---Send mail now active to---"
    echo $MAON
    echo "-------------------------------"
    for n in $MAON
    do
      ##Variable: Get mails adresses by Mount Point
      MAIL=$(psql -t --command="SELECT cont.mail
              FROM centipede.contact as cont
              LEFT JOIN public.antenne as ant ON ant.id = cont.id_antenne
              WHERE ant.mp = '$n'
                AND ant.ping_date NOTNULL;"  \
            postgresql://$POSTGRES_USER:$POSTGRES_PASS@$DB_IP/$POSTGRES_DBNAME)
      if [ -z "$MAIL" ]
      then
        echo "base " $n "non déclaré "
      else
        export MAIL=$MAIL
        export MP=$n
        /home/mail_activ.sh
        echo "mail base UP sent to " $MAIL" !!!"
      fi
    done
  ## Wait X seconds and start again.
  sleep 8
  done
exit 0
