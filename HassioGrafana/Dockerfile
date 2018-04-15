ARG BUILD_FROM=alpine:3.7

FROM ${BUILD_FROM}

ENV INFLUXDB_VERSION=1.5.2 \
    GRAFANA_VERSION=5.0.4 \
    GLIBC_VERSION=2.22 \
    GLIBC_RELEASE=r8

COPY bin /usr/bin

RUN chmod 755 /usr/bin/install.sh && /usr/bin/install.sh

COPY config/defaults.ini.tpl  /opt/grafana/conf
COPY config/influxdb.conf /etc/influxdb/influxdb.conf
COPY config/ha_datasource.yaml /opt/grafana/provisioning/datasources
COPY config/ha_datasource.yaml /opt/grafana/datasources

EXPOSE 8086 3000

CMD [ "/usr/bin/run.sh" ]
