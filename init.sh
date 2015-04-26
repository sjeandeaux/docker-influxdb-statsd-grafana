#!/bin/bash

#INIT Influxdb

isReady=666
hostInfluxdbApi=127.0.0.1:8086

until [ ! $isReady -ne 0 ]
do
   curl $hostInfluxdbApi/ping --noproxy 127.0.0.1 2> /dev/null
   isReady=$?
done

#create graphite (user and db)
#create dashboard grafana (user and db)
#db graphite
curl -X POST "$hostInfluxdbApi/db?u=root&p=root" --data '{"name": "graphite"}' --noproxy 127.0.0.1  -v 
curl -X POST "$hostInfluxdbApi/db/graphite/users?u=root&p=root" --data '{"name": "graphite", "password": "graphite"}' --noproxy 127.0.0.1  -v



#INIT Grafana
isReady=666
hostGrafanaApi=127.0.0.1:3000

until [ ! $isReady -ne 0 ]
do
   curl $hostGrafanaApi/api/login/ping --noproxy 127.0.0.1 2> /dev/null
   isReady=$?
done
 

curl -X POST "$hostGrafanaApi/login" -c cookies.txt -H 'Content-Type: application/json;charset=UTF-8'  --data-binary '{"user":"admin","email":"","password":"admin"}'

curl -X PUT "$hostGrafanaApi/api/datasources" -X PUT -b cookies.txt -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"graphite","type":"influxdb_08","url":"http://localhost:8086","access":"proxy","database":"graphite","user":"graphite","password":"graphite"}'

rm -f cookies.txt
