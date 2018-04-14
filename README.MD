# Fabbari's Hass.io Add-ons for Home Assistant

## Grafana + InfluxDB

Inspired by [Getting Started with Grafana & InfluxDB for Home Assistant](https://philhawthorne.com/getting-started-with-grafana-influxdb-for-home-assistant/)

I created this repo to deliver an Addon for HassIO that is a one stop solution
for Grafana and InfluxDB.

Currently this Addon is in Beta Stage -- use at your own risk.

## Installation

Adding this add-ons repository to your Hass.io Home Assistant instance is
pretty easy. Follow [the official instructions](https://www.home-assistant.io/hassio/installing_third_party_addons/) on the
website of Home Assistant, and use the following URL:

```txt
https://github.com/Wedjaa/hassio
```

## Configuration

### Configure Home Assistant

  If you're running this directly in hassio you should be able to access the InfluxDB for writing from HomeAssistant
with the following configuration:

```
## InfluxDB - for Grafana
influxdb:
  host: 172.30.32.1
  tags:
    instance: hassio 
    source: home_assistant
```

  You can omit the `host` part.

### Configure Grafana

To begin using the data from Home Assistant you have to create a datasource, you can use the following settings:

  * _Name_: any name you want
  * _Type_: InfluxDB
  * _URL_: http://localhost:8086/
  * _Access_: Proxy
  * _Database_: home_assistant
  * _User_: root

## Enjoy!

