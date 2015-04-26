FROM centos:latest

MAINTAINER Stéphane Jeandeaux <stephane.jeandeaux@gmail.com>


#Influxdb 
RUN curl https://s3.amazonaws.com/influxdb/influxdb-latest-1.x86_64.rpm \
       -o /tmp/influxdb.rpm \
    && rpm -ivh /tmp/influxdb.rpm \
    && rm /tmp/influxdb.rpm

RUN yum -y install tar

#Node
RUN curl -L http://nodejs.org/dist/v0.12.2/node-v0.12.2-linux-x64.tar.gz \
    -o /tmp/node.tar.gz \
    && tar --strip-components 1 -zxf /tmp/node.tar.gz -C /usr/local/ \
    && rm /tmp/node.tar.gz  
    
    
#Statsd
RUN curl -L https://github.com/etsy/statsd/archive/v0.7.2.tar.gz \
    -o /tmp/statsd.tar.gz \
    && tar --strip-components 1 -zxf /tmp/statsd.tar.gz -C /usr/local \
    && rm /tmp/statsd.tar.gz

#install Grafana
RUN yum -y install https://grafanarel.s3.amazonaws.com/builds/grafana-2.0.1-1.x86_64.rpm


#install supervisord (docker compose???)
RUN yum install -y python-setuptools
RUN easy_install supervisor

#remove command for install 
RUN yum remove -y tar

RUN yum clean all

#TODO volume statsd???
VOLUME ["/var/log/supervisor", "/opt/influxdb/shared/data", "/var/lib/grafana", "/var/log/grafana"]

# EXPOSE PORT GRAPHITE, ADMIN, API
EXPOSE 2003 3000 8083 8086 8125/udp

#script init
ADD init.sh /opt/monitoring/init.sh
RUN chmod +x /opt/monitoring/init.sh

ADD config /etc/monitoring/config
ENV CONFIG_INFLUXDB "/etc/monitoring/config/influxdb.toml"
ENV CONFIG_STATSD "/etc/monitoring/config/statsd.js"
ENV CONFIG_GRAFANA "/etc/monitoring/config/grafana.ini"

#GO...
CMD ["/usr/bin/supervisord", "-c", "/etc/monitoring/config/supervisord.conf"]
