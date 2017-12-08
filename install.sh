#!/bin/bash

export USER=pihole
export CORE_TAG=v3.2

wget https://raw.githubusercontent.com/pi-hole/pi-hole/${CORE_TAG}/automated%20install/basic-install.sh

mkdir /etc/pihole

cat << 'EOF' >> /etc/pihole/setupVars.conf
PIHOLE_INTERFACE=
IPV4_ADDRESS=0.0.0.0
IPV6_ADDRESS=
QUERY_LOGGING=true
INSTALL_WEB=true
WEBPASSWORD=
DNSMASQ_LISTENING=all
PIHOLE_DNS_1=8.8.8.8
PIHOLE_DNS_2=8.8.4.4
DNS_FQDN_REQUIRED=true
DNS_BOGUS_PRIV=true
DNSSEC=false
EOF

#/bin/sed -i '1405s/.*/installPihole  | tee ${tmpLog}/g' basic-install.sh
/bin/sed -i 's/updatePihole | tee ${tmpLog}/installPihole  | tee ${tmpLog}/g' basic-install.sh
/bin/sed -i 's|debconf-apt-progress -- "\${PKG_INSTALL\[@\]}" "\${installArray\[@\]}"|"\${PKG_INSTALL\[@\]}" "\${installArray\[@\]}"|g' basic-install.sh
/bin/bash basic-install.sh --unattended
/bin/rm basic-install.sh

apt-get -y install php7.0-zip
apt-get clean

echo -e '\nuser=root' >> /etc/dnsmasq.conf

rm -f /install.sh
