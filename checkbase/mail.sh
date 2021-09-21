#!/bin/bash

chfn -f 'Centipede '$MP'' root &&

MAILFILE=./email.txt

echo "Subject: [Centipede]:"$MP" doit avoir des problèmes..." > $MAILFILE
echo "To: " $MAIL >> $MAILFILE
echo "From: julien.ancelin@inrae.fr" >> $MAILFILE
echo "" >> $MAILFILE
echo "Message Automatique $(date '+%Y/%m/%d at %H:%M:%S') GMT." >> $MAILFILE
echo "" >> $MAILFILE
echo "Bonjour," >> $MAILFILE
echo "Votre Base RTK $MP est defaillante car les messages envoyés sont vides" >> $MAILFILE
echo "Dans un premier temps nous vous conseillons de redémarrer votre base GNSS "$MP >> $MAILFILE
echo "" >> $MAILFILE
echo "Vous pouvez visualiser la sante de l'ensemble des bases RTK Centipede sur https://centipede.fr" >> $MAILFILE
echo "En cas de difficulte technique vous pouvez demander de l'aide par mail a contact@centipede.fr" >> $MAILFILE
echo "Bonne journee" >> $MAILFILE

cat $MAILFILE | ssmtp -f"contact@centipede.fr" $MAIL
