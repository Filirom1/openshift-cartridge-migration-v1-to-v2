#!/bin/sh

LOGIN=$1
DOMAIN=$2
NAME=$3
CARTRIDGE=$4
REPO_URI=$5
EMBEDDED=$6

if [ -z "$REPO_URI" ]; then
  echo "Usage: login domain name cartidge repo_uri"
  exit 1
fi

./add-admin-key.sh $LOGIN

SSH_URI=`echo "$REPO_URI" | sed "s/ssh:\/\///g" | sed "s/\/.*//g"`

VERSION=`./check-v2.sh $SSH_URI`

if [ "$VERSION" == "2" ]
then
  echo "Cartridge already in v2"
  exit 0
fi

mkdir -p /tmp/migration/
rm -fr /tmp/migration/repo
mkdir -p /tmp/migration/repo

git clone $REPO_URI /tmp/migration/repo

curl -H"X-Remote-User:$LOGIN"  -XDELETE http://localhost:8080/broker/rest/domains/$DOMAIN/applications/$NAME

if [[ "$EMBEDDED" == *haproxy* ]]
then
  SCALE="true"
else
  SCALE="false"
fi

NEW_REPO_URI=`curl -s -H"Content-Type: application/json" -H"X-Remote-User:$LOGIN" -XPOST http://localhost:8080/broker/rest/domains/$DOMAIN/applications -d "{\"name\": \"${NAME}\", \"scale\": \"$SCALE\", \"cartridge\": {\"name\": \"$CARTRIDGE\"}}" |json data.git_url`

if [[ "$EMBEDDED" == *mysql* ]]
then
  curl  -H"X-Remote-User:$LOGIN" -XPOST http://localhost:8080/broker/rest/domains/$DOMAIN/applications/$NAME/cartridges -F"name=mysql-5.1"
fi

if [[ "$EMBEDDED" == *phpmyadmin* ]]
then
  curl  -H"X-Remote-User:$LOGIN" -XPOST http://localhost:8080/broker/rest/domains/$DOMAIN/applications/$NAME/cartridges -F"name=phpmyadmin-3.4"
fi

if [[ "$EMBEDDED" == *mongodb* ]]
then
  curl  -H"X-Remote-User:$LOGIN" -XPOST http://localhost:8080/broker/rest/domains/$DOMAIN/applications/$NAME/cartridges -F"name=mongodb-2.2"
fi

cd /tmp/migration/repo

# TODO replace OPENSHIFT_INTERNAL_IP and OPENSHIFT_INTERNAL_PORT to OPENSHIFT_${CARTRIDGE_NAME}_IP and OPENSHIFT_${CARTRIDGE_NAME}_PORT
git push -f $NEW_REPO_URI master
