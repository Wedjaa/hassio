#!/bin/sh

## Update InfluxDB Configuration

## Start InfluxDB
/usr/bin/influxd run -config /etc/influxdb/influxdb.conf -pidfile /var/run/influxdb.pid &

## Create Home Assistant DB
/usr/bin/influx -execute 'create database home_assist'

## Install the requested plugins
PLUGINS=$(jq -r  ".grafana_plugins[]"  /data/options.json)
echo "Configured plugins: ${PLUGINS}"
for plugin in ${PLUGINS}
do
  echo "Installing Grafana Plugin: $plugin"
  /opt/grafana/grafana-cli plugins install "$plugin"
done

if [ ! -f /data/defaults.ini ]
then
  /usr/bin/config.pl
fi

mkdir /data/dashboards

cp /data/defaults.ini /opt/grafana/conf/defaults.ini

## Start Grafana
/opt/grafana/grafana-server -homepath /opt/grafana

