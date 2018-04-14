#!/bin/sh

set -ex 

echo 'hosts: files dns' >> /etc/nsswitch.conf

apk update 
apk add wget tar ca-certificates curl python bash jq

ARCH=`uname -m` 
GRAFANA_INTEL="https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${GRAFANA_VERSION}.linux-x64.tar.gz" 
GRAFANA_RASP="https://github.com/fg2it/grafana-on-raspberry/releases/download/v${GRAFANA_VERSION}/grafana-${GRAFANA_VERSION}.linux-armhf.tar.gz" 
GRAFANA_URL=$([ ${ARCH} == 'x86_64' ] && echo "${GRAFANA_INTEL}" || echo "${GRAFANA_RASP}") 
curl -sL ${GRAFANA_URL} > /tmp/grafana.tgz 
INFLUX_PACK=$([ ${ARCH} == 'x86_64' ] && echo "influxdb-${INFLUXDB_VERSION}_linux_amd64.tar.gz" || echo "influxdb-${INFLUXDB_VERSION}_linux_armhf.tar.gz") 
curl -sL https://dl.influxdata.com/influxdb/releases/${INFLUX_PACK} > /tmp/influxdb.tgz 
GLIBC_REPO=$([ ${ARCH} == 'x86_64' ] && echo "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}-${GLIBC_RELEASE}" || echo "https://github.com/armhf-docker-library/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}") 
curl -sL ${GLIBC_REPO}/glibc-${GLIBC_VERSION}-${GLIBC_RELEASE}.apk > /tmp/glibc.apk 
apk add --allow-untrusted /tmp/glibc.apk 
mkdir -p /data/grafana 
mkdir -p /opt/grafana /data/grafana/data /data/grafana/dashboards 
tar xf /tmp/influxdb.tgz --strip-components=2 -C / 
tar xf /tmp/grafana.tgz --strip-components=2 -C /opt/grafana 
mkdir -p /opt/grafana/dashboards /opt/grafana/data /opt/grafana/logs /opt/grafana/plugins 
mkdir -p /var/lib/grafana/ /data/influxdb/meta /data/influxdb/data /data/influxdb/wal 
ln -s /opt/grafana/plugins /var/lib/grafana/plugins 
ln -s /opt/grafana/data /data/grafana/data 
ln -s /opt/grafana/dashboards /data/grafana/dashboards 
/opt/grafana/grafana-cli plugins update-all 
mkdir /opt/grafana/conf

chmod a+x /usr/bin/config.pl
chmod a+x /usr/bin/run.sh
