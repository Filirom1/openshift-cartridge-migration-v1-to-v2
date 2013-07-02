#!/bin/sh

USER=$1

if [ -z "$USER" ]; then
  echo "Usage: get-apps-v1 login"
  exit 1
fi

./get-apps.js $USER | while read APP; do 
  REPO_URI=`echo $APP | awk '{print $5}'`
  SSH_URI=`echo "$REPO_URI" | sed "s/ssh:\/\///g" | sed "s/\/.*//g"`
  if [ "`./check-v2.sh $SSH_URI`" != "2" ]; then
    echo $APP
  fi
done
