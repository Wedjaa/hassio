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

if 'domain' in config:
  web_domain=config['domain']
  force_domain=config['enforce_domain']
else:
  web_domain=''
  force_domain=''

admin_user=config['username']
admin_pass=config['password']

secret_key=''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(32))

with open('/opt/grafana/conf/defaults.ini.tpl', 'r') as tpl_file:
  tpl_config = tpl_file.read()

with open("/data/defaults.ini", "w") as config_file:
  config_file.write(tpl_config.format(
  WEB_PORT=web_port,
  WEB_PROTOCOL=web_protocol,
  SSL_CERT=ssl_cert,
  SSL_KEY=ssl_key,
  WEB_DOMAIN=web_domain,
  FORCE_DOMAIN=force_domain,
  ADMIN_USER=admin_user,
  ADMIN_PASS=admin_pass,
  SECRET_KEY=secret_key))

