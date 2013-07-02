#!/bin/sh

USER=$1

if [ -z "$USER" ]; then
  echo "Usage: add-admin-key login"
  exit 1
fi

TYPE=`cat ~/.ssh/id_rsa.pub | awk '{print $1}'`
CONTENT=`cat ~/.ssh/id_rsa.pub | awk '{print $2}'`

curl -s -H"X-Remote-User:$USER" -XPOST http://localhost:8080/broker/rest/user/keys -F "name=openshift-admin" -F "type=$TYPE" -F "content=$CONTENT"
