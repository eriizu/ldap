#!/bin/bash

set -e

echo ":: Stopping LDAP..."
echo " -> note: you will need to restart it upon completion."

sudo docker-compose stop ldap
sudo docker-compose run -v $(pwd)/dump:/dump ldap /restore.sh

exit

# CONT_NAME="${CONT_NAME:-ldap}"
# DOCKER="${DOCKER:-sudo docker}"
# BACKUP_SRC="${BACKUP_SRC:-backup}"

# echo ":: copying backup to container"
# $DOCKER cp $CONT_NAME $BACKUP_SRC/config.ldif /config.ldif
# $DOCKER cp $CONT_NAME $BACKUP_SRC/data.ldif /data.ldif

# echo -ne ":: purging data dir in 5 seconds...\r"
# sleep 5
# echo ":: purging data dir                "
# $DOCKER exec -it $CONT_NAME mv -v /var/lib/openldap/openldap-data/DB_CONFIG.example /tmp/DB_CONFIG.example && rm -frv /var/lib/openldap/openldap-data/ && mkdir -vp /var/lib/openldap/openldap-data/ && mv -v /tmp/DB_CONFIG.example /var/lib/openldap/openldap-data/DB_CONFIG
# echo ":: running restore"
# $DOCKER exec -it $CONT_NAME slapadd -n 0 -F /etc/openldap/slapd.d -l /config.ldif
# $DOCKER exec -it $CONT_NAME slapadd -n 1 -F /etc/openldap/slapd.d -l /data.ldif
# echo ":: ensuring ownership"
# $DOCKER exec -it $CONT_NAME chown -vR ldap:ldap /var/lib/openldap
# $DOCKER exec -it $CONT_NAME chown -vR ldap:ldap /etc/openldap/

# echo " --> restore complete"
