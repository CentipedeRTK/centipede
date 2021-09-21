#!/usr/bin/env bash
set -e
#Check docker .env data, caster conf & modify values:
#https://igs.bkg.bund.de/root_ftp/NTRIP/documentation/ntripcaster_manual.html#c8
#Maintainer: Julien Ancelin<julien.ancelin@inrae.fr>"

USERAUT=/usr/local/ntripcaster/conf/users.aut
GROUPSAUT=/usr/local/ntripcaster/conf/groups.aut
NTRIPCONF=/usr/local/ntripcaster/conf/ntripcaster.conf

if [$FIRSTADMIN = ""];
  then
      echo "No New First admin declared"
  else
    if grep -Fxq "$FIRSTADMIN:$FIRSTADMINPSWD" $USERAUT;
      then
          echo "First Admin already declared"
      else
          echo "$FIRSTADMIN:$FIRSTADMINPSWD" >>  $USERAUT
          echo "Declare First Admin : $FIRSTADMIN:$FIRSTADMINPSWD"
    fi
    if grep -Fxq "FirstAdmin:$FIRSTADMIN" $GROUPSAUT;
      then
          echo "First Admin already declared in group"
      else
          sed -i.bak 's/^FirstAdmin:.*/FirstAdmin:'$FIRSTADMIN'/' $GROUPSAUT
          echo "Declare First Admin in group FirstAdmin: $FIRSTADMIN:$FIRSTADMINPSWD"
      fi
fi
if [$NTRIPADMIN = ""];
  then
      echo "No New Ntrip admin declared"
  else
    if grep -Fxq "$NTRIPADMIN:$NTRIPADMINPSWD" $USERAUT;
      then
          echo "Ntrip Admin already declared"
      else
          echo "$NTRIPADMIN:$NTRIPADMINPSWD" >>  $USERAUT
          echo "Declare Ntrip Admin : $NTRIPADMIN:$NTRIPADMINPSWD"
    fi
    if grep -Fxq "NTRIPAdmin:$NTRIPADMIN" $GROUPSAUT;
      then
          echo "First Admin already declared in group"
      else
          sed -i.bak 's/^NTRIPAdmin:.*/NTRIPAdmin:'$NTRIPADMIN'/' $GROUPSAUT
          echo "Declare Ntrip Admin in group NtripAdmin: $FIRSTADMIN:$FIRSTADMINPSWD"
      fi
fi
if [$NTRIPUSER = ""];
  then
      echo "No New User declared"
  else
    if grep -Fxq "$NTRIPUSER:$NTRIPUSERPSWD" $USERAUT;
      then
          echo "User already declared"
      else
          echo "$NTRIPUSER:$NTRIPUSERPSWD" >>  $USERAUT
          echo "Declare User : $NTRIPUSER:$NTRIPUSERPSWD"
    fi
    if grep -Fxq "$NTRIPUSER:$NTRIPUSERPSWD" $GROUPSAUT;
      then
          echo "User already declared in group"
      else
          echo "$NTRIPUSER:$NTRIPUSERPSWD" >>  $GROUPSAUT
          echo "Declare User in group user: $NTRIPUSER:$NTRIPUSERPSWD"
    fi
fi
if [$ENCODERPSWD = ""];
  then
    echo "No New ntrip 1 pswd declared"
  else
  sed -i.bak 's/^encoder_password .*/encoder_password '$ENCODERPSWD'/' $NTRIPCONF
  echo "Ntrip1 pswd changed"
fi
#Start NTRIP caster
/usr/local/ntripcaster/bin/casterwatch
