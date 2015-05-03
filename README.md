# Docker - Influxdb - Statsd - Grafana

## Build image

```shell
make build

docker build --rm=false --force-rm=false -t sjeandeaux/docker-influxdb-statsd-grafana .
```

## Run with supervisord

```shell
make run
docker run -d --name risg -p 2003:2003 -p 3000:3000 -p 8083:8083 -p 8086:8086 -p 8125:8125/udp sjeandeaux/docker-influxdb-statsd-grafana

#Test
make send-graphite
make send-statsd

#if you like command line

host=$(if [ -n "$(which boot2docker)" ]; then boot2docker ip; else echo 127.0.0.1; fi)

echo "graphite.local.grafana.devil $1 `date +%s`" | nc $host 2003
echo "statsd.local.grafana.devil:666|c" | nc -u -w0 $host 8125

```
