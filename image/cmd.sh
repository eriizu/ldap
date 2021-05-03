#!/bin/sh

set -e

echo
echo
echo "::: LDAP is about to start :::"
echo

trap sighandler EXIT

function sighandler() {
	if [ -f /run/openldap/slapd.pid ]; then
		PID=$(cat /run/openldap/slapd.pid)
		echo "Stopping gracefully" $PID
		kill -s INT $PID
	fi
	exit 0
}

echo ":: Checking if config is ready..."
if [ ! -f /etc/openldap/init.flag ]; then
	if [ -z "${LDAP_PASSWORD}" ]; then
		echo >&2 "LDAP_PASSWORD hasn't been set."
		exit 1
	fi

	if [ -z "${LDAP_BASE_DOMAIN}" ]; then
		echo >&2 "LDAP_BASE_DOMAIN hasn't been set."
		exit 1
	fi

	if [ -z "${LDAP_DC}" ]; then
		echo >&2 "LDAP_DC hasn't been set."
		exit 1
	fi

	if [ -z "${LDAP_ORGANISATION}" ]; then
		echo >&2 "LDAP_ORGANISATION hasn't been set."
		exit 1
	fi

	echo ":: Injecting config..."
	sed -i "s/PW_TO_REPLACE/${LDAP_PASSWORD}/" /etc/openldap/slapd.conf
	sed -i "s/PW_TO_REPLACE/${LDAP_PASSWORD}/" /init.sh
	# base domain in the "dc=domain-to-replace,dc=com" format (without the quotes)
	sed -i "s/dc=domain-to-replace,dc=com/${LDAP_BASE_DOMAIN}/" /etc/openldap/slapd.conf
	sed -i "s/dc=domain-to-replace,dc=com/${LDAP_BASE_DOMAIN}/" /init.sh

	sed -i "s/dc: domain-to-replace/dc: ${LDAP_DC}/" /init.sh
	sed -i "s/o: organisation/o: ${LDAP_ORGANISATION}/" /init.sh

	echo ":: Compiling config..."
	slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/
	touch /etc/openldap/init.flag
else
	echo " --> Config is already ready."
fi

echo
echo "::: LDAP is starting :::"
echo

/usr/bin/slapd -d 256 &
CHILD_PID=$!

echo ":: Checking if init is needed..."
while [ ! -f /var/lib/openldap/openldap-data/init.flag ]; do
	echo ":: Running init script in a sec..."
	sleep 1

	# cat /init.sh
	(/init.sh && touch /var/lib/openldap/openldap-data/init.flag && echo " --> Init complete.") || true
done

wait $PID
