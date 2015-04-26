current_dir = $(shell pwd)
host = $(shell if [ -n "$(shell which boot2docker)" ]; then boot2docker ip; else echo 127.0.0.1; fi)
tag = sjeandeaux/docker-influxdb-statsd-grafana
littleName = risg
publish = -p 2003:2003 -p 3000:3000 -p 8083:8083 -p 8086:8086
