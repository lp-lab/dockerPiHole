#!/bin/bash
set -e

start_ftl() {
  touch /var/log/pihole-FTL.log /run/pihole-FTL.pid /run/pihole-FTL.port
  chown pihole:pihole /var/log/pihole-FTL.log /run/pihole-FTL.pid /run/pihole-FTL.port
  chmod 0644 /var/log/pihole-FTL.log /run/pihole-FTL.pid /run/pihole-FTL.port
  exec su -s /bin/sh -c "/usr/bin/pihole-FTL debug" "$FTLUSER"
}

set_root_passwd() {
  echo "root:$ROOT_PASSWORD" | chpasswd
}

update_timezone() {
  echo "$TIMEZONE" > /etc/timezone
}

if [[ -n $TIMEZONE ]]; then
  update_timezone
fi

set_admin_passwd() {
  pihole -a -p $ADMIN_PASS
}

if [[ -n $ADMIN_PASS ]]; then
  set_admin_passwd
fi

echo -n 'Updating Pi-Hole gravity list'
/opt/pihole/gravity.sh

echo -n 'Starting lighttpd: '
/usr/sbin/lighttpd -f /etc/lighttpd/lighttpd.conf
echo 'Ok'
echo -n '(Re)Starting dnsmasq: '
service dnsmasq restart
echo ''
echo -n 'Starting PiHole-FTL: '
start_ftl
echo 'Ok'

