include commun.mk
 
build:
	docker build --rm=false --force-rm=false -t $(tag) .

proxy-build:
	docker build -t $(tag) -f $(shell docker-proxy-file) .

rm:
	docker rm -f $(littleName)

rmi:
	docker rmi -f $(tag)

logs:
	docker logs $(littleName)

exec:
	docker exec -ti $(littleName) /bin/bash

run:
	docker run -d --name $(littleName) $(publish) $(tag)


send-graphite:
	echo "graphite.local.grafana.devil $1 `date +%s`" | nc $(host) 2003

send-statsd:
	echo "statsd.local.grafana.devil:666|c" | nc -u -w0 $(host) 8125
