#!/usr/bin/python

import json
import random
import string

config = json.load(open('/data/options.json'))

web_port='3000'

if 'ssl' in config and config['ssl']:
  web_protocol='https'
  ssl_cert="/ssl/{}".format(config['certfile'])
  ssl_key="/ssl/{}".format(config['keyfile'])
else:
  web_protocol='http'
  ssl_cert=''
  ssl_key=''

if 'grafana_ext_url' in config:
  web_url=config['grafana_ext_url']
  web_domain=web_url.split("//")[-1].split("/")[0]
  force_domain=config['enforce_domain']
else:
  web_url='http://localhost:%s' % web_port
  web_domain='localhost'
  force_domain='false'


if 'hassio_ext_url' in config:
  hassio_url = config['hassio_ext_url']
else:
  hassio_url = 'http://localhost:8123/'

admin_user=config['username']
admin_pass=config['password']

secret_key=''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(32))

with open('/opt/grafana/conf/defaults.ini.tpl', 'r') as tpl_file:
  tpl_config = tpl_file.read()

println("Filling template:\n%s\n" % tpl_config)

with open("/opt/grafana/conf/defaults.ini", "w") as config_file:
  config_file.write(tpl_config.format(
  WEB_PORT=web_port,
  WEB_PROTOCOL=web_protocol,
  SSL_CERT=ssl_cert,
  SSL_KEY=ssl_key,
  WEB_URL=web_url,
  WEB_DOMAIN=web_domain,
  FORCE_DOMAIN=force_domain,
  HASSIO_URL=hassio_url,
  ADMIN_USER=admin_user,
  ADMIN_PASS=admin_pass,
  SECRET_KEY=secret_key))

with open('/opt/grafana/conf/defaults.ini', 'r') as config_file:
  final_config = config_file.read()
  println("Filled configuration:\n%s\n" % final_config)

