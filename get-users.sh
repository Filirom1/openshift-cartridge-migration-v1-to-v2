#!/bin/sh

mongoexport --host 127.0.0.1 --port 27015 --fields "login" --collection cloud_users --db openshift_broker_dev --csv 2>/dev/null |grep -v login |sed 's/"//g'
