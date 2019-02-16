#!/usr/bin/python

import json
import random
import string
import os.path

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

if 'log_level' in config:
  log_level=config['log_level']
else:
  log_level='info'

if 'grafana_ext_url' in config:
  web_url=config['grafana_ext_url']
  web_domain=web_url.split("//")[-1].split("/")[0]
  force_domain=config['enforce_domain']
else:
  web_url='http://localhost:%s' % web_port
  web_domain='localhost'
  force_domain='false'


if 'enable_oauth' in config and config['enable_oauth']:
  oauth_enabled = "true"
  client_id = config['oauth_client']
  client_secret = config['client_secret']
  auth_url = config['auth_url']
  token_url = config['token_url']
  user_url = config['user_url']
else:
  oauth_enabled = "false"
  client_id = ''
  client_secret = ''
  auth_url = ''
  token_url = ''
  user_url = ''

admin_user=config['username']
admin_pass=config['password']

secret_key=''.join(random.choice(string.ascii_uppercase + string.digits) for _ in range(32))

with open('/opt/grafana/conf/defaults.ini.tpl', 'r') as tpl_file:
  tpl_config = tpl_file.read()

print("\n\n<<-------------------------------------------->>\n")
print("Filling template:\n%s\n" % tpl_config)

target_config="/opt/grafana/conf/defaults.ini"

if os.path.isfile("/opt/grafana/defaults.ini"):
  target_config="/opt/grafana/defaults.ini"
  
with open("/opt/grafana/conf/defaults.ini", "w") as config_file:
  config_file.write(tpl_config.format(
  WEB_PORT=web_port,
  WEB_PROTOCOL=web_protocol,
  SSL_CERT=ssl_cert,
  SSL_KEY=ssl_key,
  WEB_URL=web_url,
  LOG_LEVEL=log_level,
  WEB_DOMAIN=web_domain,
  OAUTH_ENABLED=oauth_enabled,
  CLIENT_ID=client_id,
  CLIENT_SECRET=client_secret,
  AUTH_URL=auth_url,
  TOKEN_URL=token_url,
  USER_URL=user_url,
  FORCE_DOMAIN=force_domain,
  ADMIN_USER=admin_user,
  ADMIN_PASS=admin_pass,
  SECRET_KEY=secret_key))

with open('/opt/grafana/conf/defaults.ini', 'r') as config_file:
  final_config = config_file.read()
  print("\n\n<<-------------------------------------------->>\n")
  print("Filled configuration:\n%s\n" % final_config)

