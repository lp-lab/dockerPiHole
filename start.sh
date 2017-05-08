#!/bin/bash

docker run --name bind -d --restart=always \
  --publish <ip>:53:53/tcp \
  --publish <ip>:53:53/udp \
  --publish <ip>:10000:10000/tcp \
  --volume /srv/docker/bind:/data \
  -v /srv/docker/bind/bindlog:/var/log/named \
  --env ROOT_PASSWORD=<password> \
  lplab/dockerdns:sid -g -4
