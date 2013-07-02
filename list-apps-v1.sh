#!/bin/bash

./get-users.sh | while read USER; do
  ./add-admin-key.sh $USER >/dev/null
  ./get-apps-v1.sh $USER;
done
