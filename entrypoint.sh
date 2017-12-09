#!/bin/bash
set -e

#readonly setupVars="/etc/pihole/setupVars.conf"
IP="${ServerIP:-'0.0.0.0'}"
IPV6="${ServerIPv6}"

start_ftl() {
  touch /var/log/pihole-FTL.log /run/pihole-FTL.pid /run/pihole-FTL.port
  chown pihole:pihole /var/log/pihole-FTL.log /run/pihole-FTL.pid /run/pihole-FTL.port
  chmod 0644 /var/log/pihole-FTL.log /run/pihole-FTL.pid /run/pihole-FTL.port
  /usr/bin/pihole-FTL
}

set_ip_address() {
  sed -i "/${1}/d" "${setupVars}"
  echo "${1}=${2}" >> "${setupVars}"
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

setup_dnsmasq_dns() {
    . /opt/pihole/webpage.sh
    local DNS1="${1:-8.8.8.8}"
    local DNS2="${2:-8.8.4.4}"
    local dnsType='default'
    if [ "$DNS1" != '8.8.8.8' ] || [ "$DNS2" != '8.8.4.4' ] ; then
      dnsType='custom'
    fi;

    echo "Using $dnsType DNS servers: $DNS1 & $DNS2"
        [ -n "$DNS1" ] && change_setting "PIHOLE_DNS_1" "${DNS1}"
        [ -n "$DNS2" ] && change_setting "PIHOLE_DNS_2" "${DNS2}"
    ProcessDNSSettings
}

setup_localversion() {
    . ./opt/pihole/updatecheck.sh
}

if [[ -n $ADMIN_PASS ]]; then
  set_admin_passwd
fi

setup_dnsmasq_dns "$DNS1" "$DNS2"

set_ip_address "IPV4_ADDRESS" "$IP"

if [ -n "$IPV6" ] ; then
  set_ip_address "IPV6_ADDRESS" "$IPv6"
fi;

echo 'Ok'
echo -n '(Re)Starting dnsmasq: '
service dnsmasq restart
echo ''
echo -n 'Starting PiHole-FTL: '
start_ftl
echo 'Ok'
echo -n 'Updating Pi-Hole gravity list'
echo Gravity
/opt/pihole/gravity.sh
#echo tail
#exec tail -F /var/log/pihole*.log
setup_localversion
echo -n 'Starting lighttpd: '
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf
