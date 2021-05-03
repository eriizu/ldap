#!/bin/sh

echo -ne ":: purging data dir in 5 seconds...\r"
sleep 5
echo ":: purging data dir                "
mv -v /var/lib/openldap/openldap-data/DB_CONFIG.example /tmp/DB_CONFIG.example && rm -frv /var/lib/openldap/openldap-data/ && mv -v /tmp/DB_CONFIG.example /var/lib/openldap/openldap-data/DB_CONFIG
# mv -v /var/lib/openldap/openldap-data/DB_CONFIG.example /tmp/DB_CONFIG.example && rm -frv /var/lib/openldap/openldap-data/ && mkdir -vp /var/lib/openldap/openldap-data/ && mv -v /tmp/DB_CONFIG.example /var/lib/openldap/openldap-data/DB_CONFIG
echo ":: setting slapd config"
cp -v /dump/slapd.conf /etc/openldap/
slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/

touch /etc/openldap/init.flag

echo ":: running restore"
slapadd -n 0 -F /etc/openldap/slapd.d -l /dump/config.ldif
slapadd -n 1 -F /etc/openldap/slapd.d -l /dump/data.ldif
echo ":: ensuring ownership"
chown -vR ldap:ldap /var/lib/openldap
chown -vR ldap:ldap /etc/openldap/

touch /var/lib/openldap/openldap-data/init.flag
echo " --> restore complete"
