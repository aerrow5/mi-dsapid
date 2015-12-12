
log "creating /data directory"

if [[ ! -e /data ]]; then
  mkdir /data
  mkdir /data/files
fi

if [[ ! -e /data/config.json ]]; then
  log "creating initial configuration"

  cat > /data/config.json << EOF
{
  "log_level": "info",
  "base_url": "http://${HOSTNAME}/",
  "mount_ui": "/opt/dsapid/ui",
  "listen": {
    "http": {
      "address": "0.0.0.0:8000",
      "ssl": false
    }
  },
  "datadir": "/data/files",
  "users": "/data/users.json",
  "sync": [
    {
      "name": "datasets.at repository",
      "active": true,
      "type": "dsapi",
      "provider": "community",
      "source": "http://datasets.at/datasets?name=base-64&amp;version=15.3.0",
      "delay": "24h"
    }
  ]
}
EOF
fi

if [[ ! -e /data/users.json ]]; then
  log "creating initial users list and seed it with joyent uuids"

  cat > /data/users.json << EOF
[
  {
    "uuid": "352971aa-31ba-496c-9ade-a379feaecd52",
    "name": "sdc",
    "type": "system",
    "provider": "joyent"
  },
  {
    "uuid": "684f7f60-5b38-11e2-8eae-6b88dd42e590",
    "name": "sdc",
    "type": "system",
    "provider": "joyent"
  },
  {
    "uuid": "a979f956-12cb-4216-bf4c-ae73e6f14dde",
    "name": "sdc",
    "type": "system",
    "provider": "joyent"
  },
  {
    "uuid": "9dce1460-0c4c-4417-ab8b-25ca478c5a78",
    "name": "jpc",
    "type": "system",
    "provider": "joyent"
  },
  {
    "uuid": "12345678-1234-1234-1234-123456789012",
    "name": "admin",
    "token": "admin",
    "roles": ["s_dataset.upload","s_dataset.manage","s_dataset.admin","admin"],
    "type": "user",
    "provider": "community"
  }
]
EOF
fi

log "force correct ownership of /data directory"

chown -R dsapid:dsapid /data

log "starting dsapid"

/usr/sbin/svcadm enable dsapid
