#!/bin/sh

ldapadd -x -D 'cn=root,dc=domain-to-replace,dc=com' -w PW_TO_REPLACE <<EOF
dn: dc=domain-to-replace,dc=com
objectClass: dcObject
objectClass: organization
dc: domain-to-replace
o: organisation
description: User and Staff directory

dn: cn=root,dc=domain-to-replace,dc=com
objectClass: organizationalRole
cn: root
description: Directory Manager

EOF
