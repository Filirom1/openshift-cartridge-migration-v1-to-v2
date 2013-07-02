#!/bin/bash

CART_EXPECTED=$1


if [ -z "$CART_EXPECTED" ]; then
  echo "Usage: migrate_simple.sh nodejs-0.6"
  exit 1
fi

./get-users.sh | while read USER; do
  ./add-admin-key.sh $USER >/dev/null
  ./get-apps-v1.sh $USER | while read APP; do
    EMBEDDED=`echo $APP | awk '{print $6}'`
    CARTRIDGE=`echo $APP | awk '{print $4}'`
    if [ "$CARTRIDGE" = "$CART_EXPECTED" ]; then
      echo $APP
      ./migrate.sh $APP
    fi
  done
done
