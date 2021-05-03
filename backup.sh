#!/bin/sh

set -e

CONT_NAME="${CONT_NAME:-ldap}"
DOCKER="${DOCKER:-sudo docker}"
BACKUP_DEST="${BACKUP_DEST:-dump}"

mkdir --parents $BACKUP_DEST

[ "$(ls -A $BACKUP_DEST)" ] && echo -e "$BACKUP_DEST directory is not empty, you might consider emptying it before backing up.\n:: Waiting a few seconds if you want to cancel..." && sleep 4

$DOCKER exec -it $CONT_NAME slapcat -n 0 >$BACKUP_DEST/config.ldif
$DOCKER exec -it $CONT_NAME slapcat -n 1 >$BACKUP_DEST/data.ldif
$DOCKER exec -it $CONT_NAME cat /etc/openldap/slapd.conf >$BACKUP_DEST/slapd.conf

echo " --> backup conplete."
